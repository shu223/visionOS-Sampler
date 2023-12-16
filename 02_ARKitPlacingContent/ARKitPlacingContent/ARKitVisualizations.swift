//
//  ARKitVisualizations.swift
//  ARKitPlacingContent
//
//  Created by Shuichi Tsutsumi on 2023/11/30.
//

import ARKit
import SwiftUI

// Reference: https://github.com/satoshi0212/visionOS_30Days
extension PlaneAnchor.Classification {

    var color: UIColor {
        switch self {
        case .wall:
            return UIColor.blue.withAlphaComponent(0.65)
        case .floor:
            return UIColor.red.withAlphaComponent(0.65)
        case .ceiling:
            return UIColor.green.withAlphaComponent(0.65)
        case .table:
            return UIColor.yellow.withAlphaComponent(0.65)
        case .door:
            return UIColor.brown.withAlphaComponent(0.65)
        case .seat:
            return UIColor.systemPink.withAlphaComponent(0.65)
        case .window:
            return UIColor.orange.withAlphaComponent(0.65)
        case .undetermined:
            return UIColor.lightGray.withAlphaComponent(0.65)
        case .notAvailable:
            return UIColor.gray.withAlphaComponent(0.65)
        case .unknown:
            return UIColor.black.withAlphaComponent(0.65)
        @unknown default:
            return UIColor.purple
        }
    }
}
