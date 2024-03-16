//
//  ARViewWrapper.swift
//  AIAR
//
//  Created by Peter Sheehan on 16/03/2024.
//

import RealityKit
import ARKit

/// A class responsible for managing the AR view and handling the loading of 3D models into the AR scene.
///
/// This class wraps around an instance of `ARView`, hence it is called `ARViewWrapper`.
class ARViewWrapper: ObservableObject {
    
    /// The ARView instance used to display the augmented reality scene.
    let arView: ARView
    
    /// The detected image anchor used as a reference for placing 3D models in the AR scene.
    var detectedImageAnchor: ARImageAnchor?
    
    /// Initialises the ARViewWrapper and creates an ARView instance.
    init() {
        self.arView = ARView(frame: .zero)
    }
    
    /// Loads a 3D model into the AR scene at the location of the detected QR code image anchor.
    /// - Parameters:
    ///   - path: The path to the `USDZ` file containing the 3D model.
    ///   - imageAnchor: The ARImageAnchor representing the detected QR code image.
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
    
    /// Resets the AR view by removing all existing anchors and restarting the AR session with new reference images.
    /// - Parameter referenceImages: The set of AR reference images used for image detection.
    func resetARView(withReferenceImages referenceImages: Set<ARReferenceImage>) {
        self.arView.session.pause()
        self.arView.scene.anchors.removeAll()
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        self.arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
