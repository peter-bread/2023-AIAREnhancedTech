//
//  ARViewContainer.swift
//  DatabaseDemo
//
//  Created by Peter Sheehan on 13/02/2024.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

enum ARAction {
    case resetARView
    case loadModel(path: String, anchor: ARImageAnchor)
}

class ARManager {
    static let shared = ARManager()
    let actionStream = PassthroughSubject<ARAction, Never>()
}

struct ARViewContainer: UIViewRepresentable {
    
    var referenceImages: Set<ARReferenceImage>
    @Binding var shouldReset: Bool
    
    @State var detectedImageAnchor: ARImageAnchor?
    @State var modelPath: String?
    
    @ObservedObject var arWrapper = ARWrapper()

    func makeUIView(context: Context) -> ARView {
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        arWrapper.arView.session.delegate = context.coordinator
        arWrapper.arView.session.run(configuration)
        return arWrapper.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if shouldReset {
            print("Resetting ARView")
            arWrapper.resetARView(withReferenceImages: referenceImages)
            shouldReset = false
        }
        
        guard
            let imageAnchor = detectedImageAnchor,
            let path = modelPath
        else {
            return
        }
        
        uiView.scene.anchors.removeAll()
        arWrapper.loadModel(path: path, imageAnchor: imageAnchor)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, ARSessionDelegate {
    private var parent: ARViewContainer
    private var actionStreamSubscription: AnyCancellable?

    init(_ parent: ARViewContainer) {
        self.parent = parent
        super.init()
        subscribeToActionStream()
    }
    
    func subscribeToActionStream() {
        actionStreamSubscription = ARManager.shared.actionStream.sink { [weak self] action in
            guard let self = self else { return }
            
            /*
             These events change the @Binding and @State Property Wrapper variables in ARViewContainer.
             Since these variables are reactive, updating them automatically invokes `updateUIView()`,
             so the ARView is reset and models are loaded in there (although the logic for that is in
             a wrapper class.
            */
            
            switch action {
            case .resetARView:
                print("Resetting ARView")
                DispatchQueue.main.async {
                    self.parent.shouldReset = true
                }
            case .loadModel(let path, let imageAnchor):
                print("Loading model")
                DispatchQueue.main.async {
                    self.parent.detectedImageAnchor = imageAnchor
                    self.parent.modelPath = path
                }
            }
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if
                let imageAnchor = anchor as? ARImageAnchor,
                let path = imageAnchor.referenceImage.name
            {
                print("Detected Image: \(path)")
                ARManager.shared.actionStream.send(.loadModel(path: path, anchor: imageAnchor))
            }
        }
    }
}
