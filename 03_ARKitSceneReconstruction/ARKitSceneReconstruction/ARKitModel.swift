//
//  ARKitModel.swift
//  ARKitPlacingContent
//
//  Created by Shuichi Tsutsumi on 2023/10/04.
//

import RealityKit
import ARKit

final class ARKitModel: ObservableObject {
    private let session = ARKitSession()
    private let sceneReconstruction = SceneReconstructionProvider(modes: [.classification])

    let rootEntity = Entity()

    private var meshEntities = [UUID: ModelEntity]()

    func run() async {
        guard PlaneDetectionProvider.isSupported else {
            print("PlaneDetectionProvider is NOT supported.")
            return
        }

        do {
            try await session.run([sceneReconstruction])
            print("ARKit session is running...")
            for await update in sceneReconstruction.anchorUpdates {
                print("update: \(update)")
                print("Updated a portion of the scene: ", update.anchor)
                // Update app with new surroundings.
                await processMeshAnchorUpdate(update)
            }
        } catch {
            print("ARKit session error \(error)")
        }
    }

    @MainActor
    func processMeshAnchorUpdate(_ update: AnchorUpdate<MeshAnchor>) async {
        let meshAnchor = update.anchor

        guard let shape = try? await ShapeResource.generateStaticMesh(from: meshAnchor) else { return }
        switch update.event {
        case .added:
            let entity = try! await generateModelEntity(geometry: meshAnchor.geometry)

            entity.transform = Transform(matrix: meshAnchor.originFromAnchorTransform)
            entity.collision = CollisionComponent(shapes: [shape], isStatic: true)
            entity.components.set(InputTargetComponent())

            entity.physicsBody = PhysicsBodyComponent(mode: .static)

            meshEntities[meshAnchor.id] = entity
            rootEntity.addChild(entity)
        case .updated:
            guard let entity = meshEntities[meshAnchor.id] else { return }
            entity.transform = Transform(matrix: meshAnchor.originFromAnchorTransform)
            entity.collision?.shapes = [shape]
        case .removed:
            meshEntities[meshAnchor.id]?.removeFromParent()
            meshEntities.removeValue(forKey: meshAnchor.id)
        }
    }

    // Reference: https://github.com/XRealityZone/what-vision-os-can-do/blob/3a731b5645f1c509689637e66ee96693b2fa2da7/WhatVisionOSCanDo/ShowCase/WorldScening/WorldSceningTrackingModel.swift
    @MainActor func generateModelEntity(geometry: MeshAnchor.Geometry) async throws -> ModelEntity {
        // generate mesh
        var desc = MeshDescriptor()
        let posValues = geometry.vertices.asSIMD3(ofType: Float.self)
        desc.positions = .init(posValues)
        let normalValues = geometry.normals.asSIMD3(ofType: Float.self)
        desc.normals = .init(normalValues)
        do {
            desc.primitives = .polygons(
                (0..<geometry.faces.count).map { _ in UInt8(3) },
                (0..<geometry.faces.count * 3).map {
                    geometry.faces.buffer.contents()
                        .advanced(by: $0 * geometry.faces.bytesPerIndex)
                        .assumingMemoryBound(to: UInt32.self).pointee
                }
            )
        }
        let meshResource = try MeshResource.generate(from: [desc])
        let material = SimpleMaterial(color: .blue.withAlphaComponent(0.7), isMetallic: false)
        let modelEntity = ModelEntity(mesh: meshResource, materials: [material])
        return modelEntity
    }
}

// Reference: https://github.com/XRealityZone/what-vision-os-can-do/blob/3a731b5645f1c509689637e66ee96693b2fa2da7/WhatVisionOSCanDo/Extension/GeometrySource.swift
extension GeometrySource {
    @MainActor func asArray<T>(ofType: T.Type) -> [T] {
        assert(MemoryLayout<T>.stride == stride, "Invalid stride \(MemoryLayout<T>.stride); expected \(stride)")
        return (0..<self.count).map {
            buffer.contents().advanced(by: offset + stride * Int($0)).assumingMemoryBound(to: T.self).pointee
        }
    }

    // SIMD3 has the same storage as SIMD4.
    @MainActor  func asSIMD3<T>(ofType: T.Type) -> [SIMD3<T>] {
        return asArray(ofType: (T, T, T).self).map { .init($0.0, $0.1, $0.2) }
    }
}
