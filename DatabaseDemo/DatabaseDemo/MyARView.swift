//
//  MyARView.swift
//  DatabaseDemo
//
//  Created by Peter Sheehan on 14/03/2024.
//

import SwiftUI
import ARKit

struct MyARView: View {
    /// Set of `ARReferenceImage` that will be used to detect images in the real world
    var referenceImages: Set<ARReferenceImage>
    
    @Binding var shouldReset: Bool
    
    var body: some View {
        ARViewContainer(referenceImages: referenceImages, shouldReset: $shouldReset)
            .ignoresSafeArea()
        
            // overlays (for now) one button on the ARiew inside ARViewContainer so
            // the user can reset the ARView whenever it stops working.
            .overlay(alignment: .bottom, content: {
                Button(action: {
                    self.shouldReset = true
                    print("Reset Button Clicked")
                }) {
                    VStack {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .rotationEffect(.degrees(-30))
                        Text("Reset AR")
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .background(.regularMaterial)
                    .cornerRadius(16)
                }
                .padding()
            })
    }
}
