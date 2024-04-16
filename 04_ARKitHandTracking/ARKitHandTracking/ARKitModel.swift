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
    private let handTracking = HandTrackingProvider()
    
    let rootEntity = Entity()
    
    @Published var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)
    
    struct HandsUpdates {
        var left: HandAnchor?
        var right: HandAnchor?
    }
    
    func run() async {
        guard HandTrackingProvider.isSupported else {
            print("PlaneDetectionProvider is NOT supported.")
            return
        }
        
        do {
            try await session.run([handTracking])
            print("ARKit session is running...")
            await processHandAnchorUpdates()
        } catch {
            print("ARKit session error \(error)")
        }
    }
    
    @MainActor
    func processHandAnchorUpdates() async {
        for await update in handTracking.anchorUpdates {
            switch update.event {
            case .updated:
                let anchor = update.anchor

                guard anchor.isTracked, let handSkeleton = anchor.handSkeleton else { continue }
                updateFingerEnity(idPrefix: anchor.chirality.description, rootTransform: anchor.originFromAnchorTransform, skeleton: handSkeleton)
            default:
                break
            }
        }
    }
    

    // Reference: https://github.com/XRealityZone/what-vision-os-can-do/blob/main/WhatVisionOSCanDo/ShowCase/HandTracking/HandTrackingModel.swift
    private func updateFingerEnity(idPrefix: String, rootTransform: simd_float4x4, skeleton: HandSkeleton) {
        for joint in skeleton.allJoints {
            let name = "\(idPrefix)-\(joint.name)"
            if let entity = rootEntity.findEntity(named: name) {
                if joint.isTracked {
                    entity.setTransformMatrix(rootTransform * joint.anchorFromJointTransform, relativeTo: nil)
                    entity.scale = simd_float3(repeating: 0.01)
                    entity.isEnabled = true
                } else {
                    entity.isEnabled = false
                }

            } else {
                guard joint.isTracked else { continue }
                let entity = ModelEntity(mesh: .generateSphere(radius: 1), materials: [SimpleMaterial(color: .green.withAlphaComponent(0.5), isMetallic: false)])
                entity.name = name
                entity.setTransformMatrix(rootTransform * joint.anchorFromJointTransform, relativeTo: nil)
                entity.scale = simd_float3(repeating: 0.01)
                rootEntity.addChild(entity)
            }
        }
    }
}
