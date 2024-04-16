//
//  ImmersiveView.swift
//
//  Created by Shuichi Tsutsumi on 2024/04/16.
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
