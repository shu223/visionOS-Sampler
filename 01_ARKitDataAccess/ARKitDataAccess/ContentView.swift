//
//  ContentView.swift
//  ARKitDataAccess
//
//  Created by Shuichi Tsutsumi on 2023/10/03.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    var body: some View {
        Button("Start ARKit experience") {
            Task {
                await openImmersiveSpace(id: "appSpace")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
