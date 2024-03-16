//
//  ARAction.swift
//  AIAR
//
//  Created by 陈若鑫 on 31/01/2024.
//

import SwiftUI
import ARKit

enum ARAction {
    case resetARView
    case loadModel(path: String, anchor: ARImageAnchor)
}
