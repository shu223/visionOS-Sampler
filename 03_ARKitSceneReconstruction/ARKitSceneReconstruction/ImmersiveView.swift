//
//  ImmersiveView.swift
//  ARKitSceneReconstruction
//
//  Created by Shuichi Tsutsumi on 2023/10/04.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    private let model = ARKitModel()

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            content.add(model.rootEntity)
        }
        .task {
            await model.run()
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
