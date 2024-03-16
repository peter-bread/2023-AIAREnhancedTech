//
//  Intropage.swift
//  AIAR
//
//  Created by 陈若鑫 on 31/01/2024.
//
import SwiftUI

struct ContentView: View {
    
    /// An instance of QRCodeService to handle loading QR codes.
    @StateObject private var qrCodeService = QRCodeService()
    
    /// A state variable that determines whether the AR view should be reset.
    ///
    /// When this variable is set to true, the AR view is reset.
    ///
    /// It should be set back to false after the reset is complete.
    @State private var shouldReset = false
    // It is bound to a corresponding variable in `ARViewContainer`.
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VideoPlayerRepresentable()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Text("Welcome to")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .scaleEffect(1.2) // Increase the size by 50%
                        .shadow(color: Color.black, radius: 3, x: 0, y: 5)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, -220)
                    
                    Text("Galasa AI AR")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .scaleEffect(1.5) // Increase the size by 50%
                        .shadow(color: Color.black, radius: 3, x: 0, y: 5)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, -180)
                    
                    Text("Technical Document Enhancer")
                        .font(.title)
                        .scaleEffect(0.6) // Increase the size by 50%
                        .shadow(color: Color.black, radius: 3, x: 0, y: 5)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.top, -145) // Add bottom padding for space
                    
                    var dynamicARViewButtonText: String {
                        return !qrCodeService.referenceImages.isEmpty ? "Open AR View" : "Fetching QR Codes..."
                    }
                    
                    var dynamicARViewButtonForegroundColor: Color {
                        return !qrCodeService.referenceImages.isEmpty ? .white : .gray
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: { ActualARView(referenceImages: qrCodeService.referenceImages, shouldReset: $shouldReset)
                    }) {
                        Text(dynamicARViewButtonText)
                            .padding(20)
                            .buttonStyle(.bordered)
                            .foregroundColor(dynamicARViewButtonForegroundColor)
                            .background(.regularMaterial)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 10)
                    .disabled(qrCodeService.referenceImages.isEmpty) // cannot enter ARView until all QR codes have been loaded
                    // in future, if there are lots of sets of QR codes/models, maybe allows users to download a set of QR codes rather than
                    // all of them???
                    
                    NavigationLink(destination: { InstructionsView()
                    }) {
                        Text("Instructions")
                            .padding(20)
                            .background(.regularMaterial)
                            .foregroundColor(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 10)
                    
                    Spacer()
                    
                    NavigationLink(destination: { TeamView()
                    }) {
                        Text("Developer introduction")
                            .padding(20)
                            .foregroundColor(Color.white)
                            .buttonStyle(.borderless)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 10)

                }
            }
        }
        .navigationBarTitle("Main Page")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
