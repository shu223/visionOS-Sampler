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
    private let provider = PlaneDetectionProvider(alignments: [.horizontal, .vertical])
    let rootEntity = Entity()

    @Published var entityMap: [UUID: Entity] = [:]

    func run() async {
        guard PlaneDetectionProvider.isSupported else {
            print("PlaneDetectionProvider is NOT supported.")
            return
        }

        do {
            try await session.run([provider])
            print("ARKit session is running...")
            for await update in provider.anchorUpdates {
                print("anchorUpdate: \(update)")
                // Skip planes that are windows.
                if update.anchor.classification == .window { continue }

                switch update.event {
                case .added, .updated:
                    await updatePlane(update.anchor)
                case .removed:
                    removePlane(update.anchor)
                }
            }
        } catch {
            print("ARKit session error \(error)")
        }
    }

    @MainActor
    func updatePlane(_ anchor: PlaneAnchor) {
        if let entity = entityMap[anchor.id] {
            print("updating existing plane anchor: \(anchor.id), classification: \(anchor.classification.description)")
            let planeEntity = entity.findEntity(named: "plane") as! ModelEntity
            let newMesh = MeshResource.generatePlane(width: anchor.geometry.extent.width, height: anchor.geometry.extent.height)
//            print("old mesh: \(planeEntity.model!.mesh.contents), new mesh: \(newMesh.contents)")
            // メッシュの更新
//            try! planeEntity.model!.mesh.replace(with: newMesh.contents)
            planeEntity.model!.mesh = newMesh

            planeEntity.transform = Transform(matrix: anchor.geometry.extent.anchorFromExtentTransform)
        } else {
            print("adding plane anchor: \(anchor), classification: \(anchor.classification.description)")
            // Add a new entity to represent this plane.
            let entity = Entity()

            let material = UnlitMaterial(color: anchor.classification.color)
            let planeEntity = ModelEntity(mesh: .generatePlane(width: anchor.geometry.extent.width, height: anchor.geometry.extent.height), materials: [material])
            planeEntity.name = "plane"
            planeEntity.transform = Transform(matrix: anchor.geometry.extent.anchorFromExtentTransform)

            let textEntity = ModelEntity(
                mesh: .generateText(anchor.classification.description)
            )
            textEntity.scale = SIMD3(0.01, 0.01, 0.01)

            entity.addChild(planeEntity)
            planeEntity.addChild(textEntity)

            entityMap[anchor.id] = entity
            rootEntity.addChild(entity)
        }

        // originFromAnchorTransform: The location and orientation of a plane in world space.
        entityMap[anchor.id]?.transform = Transform(matrix: anchor.originFromAnchorTransform)
    }

    func removePlane(_ anchor: PlaneAnchor) {
        entityMap[anchor.id]?.removeFromParent()
        entityMap.removeValue(forKey: anchor.id)
    }
}
