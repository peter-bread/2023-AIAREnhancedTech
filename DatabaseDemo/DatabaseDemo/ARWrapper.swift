//
//  ARWrapper.swift
//  DatabaseDemo
//
//  Created by Peter Sheehan on 16/03/2024.
//

import RealityKit
import ARKit

class ARWrapper: ObservableObject {
    let arView: ARView
    var detectedImageAnchor: ARImageAnchor?
    
    init() {
        self.arView = ARView(frame: .zero)
    }
    
    func loadModel(path: String, imageAnchor: ARImageAnchor) {
        
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
                    self.arView.scene.addAnchor(anchorEntity)
                } catch {
                    print("Error loading USDZ data into RealityKit: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    func resetARView(withReferenceImages referenceImages: Set<ARReferenceImage>) {
        
        self.arView.session.pause()
        self.arView.scene.anchors.removeAll()
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        self.arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
}
