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

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    
    var referenceImages: Set<ARReferenceImage>
    @Binding var shouldReset: Bool
    
    @State var detectedImageAnchor: ARImageAnchor?
    @State var modelPath: String?

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        arView.session.delegate = context.coordinator
        arView.session.run(configuration)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if shouldReset {
            print("Resetting ARView")
            uiView.session.pause()
            uiView.scene.anchors.removeAll()
            
            let configuration = ARWorldTrackingConfiguration()
            configuration.detectionImages = referenceImages
            uiView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            
            // Reset the state to avoid continuous resetting
            shouldReset = false
        }
        
        guard let imageAnchor = detectedImageAnchor, let path = modelPath else {return}
            uiView.scene.anchors.removeAll()

            // Download the usdz file from Firebase Storage
            USDZLoader().asyncDownloadUSDZ(from: path) { fileURL in
                DispatchQueue.main.async {
                    do {
                        // Load the usdz file into an `Entity`
                        let usdzEntity = try Entity.loadModel(contentsOf: fileURL)
                        
                        // Create an `AnchorEntity` at the location of the detected QR code image
                        let anchorEntity = AnchorEntity(anchor: imageAnchor) // Place the anchor at the origin
                        
                        // temporary rotation (the models I am using do not have built-in anchors so I have to
                        // orient them manually here)
                        // if models are not all oriented the same way, I will include the necessary rotation data in the metadata and read that
                        
                        let rotation1 = simd_quatf(angle: -1 * .pi / 2, axis: [1, 0, 0])
                        let rotation2 = simd_quatf(angle: -1 * .pi / 2, axis: [0, 1, 0])
                        
                        let rotation = rotation1 * rotation2
                        
                        usdzEntity.transform.rotation = rotation

                        // Add the `Entity` to the `AnchorEntity` and add the `AnchorEntity` to the AR scene
                        anchorEntity.addChild(usdzEntity)
                        uiView.scene.addAnchor(anchorEntity)
                    } catch {
                        print("Error loading USDZ data into RealityKit: \(error.localizedDescription)")
                    }
                }
            }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, ARSessionDelegate {
    var parent: ARViewContainer
    var actionStreamSubscription: AnyCancellable?

    init(_ parent: ARViewContainer) {
        
        self.parent = parent
        super.init()

        actionStreamSubscription = ARManager.shared.actionStream.sink { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .resetARView:
                print("Resetting ARView")
                DispatchQueue.main.async {
                    self.parent.shouldReset = true
                }
            case .loadModel(let path, let imageAnchor):
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
                self.parent.detectedImageAnchor = imageAnchor
                self.parent.modelPath = path
            }
        }
    }
}
