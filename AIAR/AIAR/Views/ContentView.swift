//
//  Intropage.swift
//  AIAR
//
//  Created by 陈若鑫 on 31/01/2024.
//
import SwiftUI
import AVKit

/// View to display a video.
struct VideoPlayerView: UIViewRepresentable {
    
    //video from: https://www.youtube.com/watch?v=RhlQvbvMg-0
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let player = AVPlayer(url : Bundle.main.url(forResource:"backgroundVideo1", withExtension: "mov")!)
        
        // ensure video is muted (the video is already silent, this just makes sure)
        player.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        // Configure audio session to not interrupt other audio sources
        // This means Spotify or Apple Music can continue to play while the app is open
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
        
        player.play()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}


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
        
        return NavigationView {
            ZStack {
                VideoPlayerView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                VStack {
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
                    
                    var arViewButtonText: String {
                        return !qrCodeService.referenceImages.isEmpty ? "Open AR View" : "Fetching QR Codes..."
                    }
                    
                    var fg: Color {
                        return !qrCodeService.referenceImages.isEmpty ? .black : .gray
                    }
                    
                    var bg: Color {
                        return !qrCodeService.referenceImages.isEmpty ? .white : .clear
                    }
                    
                    NavigationLink(destination: { ActualARView(referenceImages: qrCodeService.referenceImages, shouldReset: $shouldReset)
                    }) {
                        Text(arViewButtonText)
                            .padding()
                            .fontWeight(.semibold)
                            .buttonStyle(.bordered)
                            .foregroundColor(fg)
                            .background(bg)
                            .cornerRadius(8)
                            .shadow(color: Color.black, radius: 3, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .padding(.bottom, 10)
                    .disabled(qrCodeService.referenceImages.isEmpty) // cannot enter ARView until all QR codes have been loaded
                    // in future, if there are lots of sets of QR codes/models, maybe allows users to download a set of QR codes rather than
                    // all of them???
                    
                    NavigationLink(destination: { TeamView()
                    }) {
                        Text("Developer introduction")
                            .fontWeight(.semibold)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color.black)
                            .cornerRadius(8)
                            .shadow(color: Color.black, radius: 3, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .padding(.bottom, 10)
                    
                    NavigationLink(destination: { InstructionsView()
                    }) {
                        Text("Instructions")
                            .fontWeight(.semibold)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color.black)
                            .cornerRadius(8)
                            .shadow(color: Color.black, radius: 3, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
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
