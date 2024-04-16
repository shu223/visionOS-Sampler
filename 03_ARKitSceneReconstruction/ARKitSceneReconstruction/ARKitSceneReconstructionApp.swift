//
//  ARKitSceneReconstructionApp.swift
//  ARKitSceneReconstruction
//
//  Created by Shuichi Tsutsumi on 2023/10/04.
//

import SwiftUI

@main
struct ARKitSceneReconstructionApp: App {
    @State var immersionState: ImmersionStyle = .mixed
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .immersionStyle(selection: $immersionState, in: .mixed)
    }
}
