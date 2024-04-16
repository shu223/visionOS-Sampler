//
//  ARKitHandTrackingApp.swift
//  ARKitHandTrackingApp
//
//  Created by Shuichi Tsutsumi on 2024/04/16.
//

import SwiftUI

@main
struct ARKitHandTrackingApp: App {
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
