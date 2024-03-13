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
        
        // ensure video is muted (the video is alreayd silent, this just makes sure)
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
    
    // TODO: add QRCodeService
    // TODO: add shouldReset
    
    var body: some View {
        
        return NavigationView{
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
                    
                    Text("Galasa AR AI")
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
                    
                    // TODO: This is the Button that needs to be changed
                    NavigationLink(destination: ARACTUAL()) {
                        Text("Go to AR View")
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
                    .padding(.bottom, 10) // Add bottom padding for space
                    
                    NavigationLink(destination: TeamRepresentable()) {
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
                    .padding(.bottom, 10) // Add bottom padding for space
                    
                    NavigationLink(destination: InstructionsView()) {
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
                    .padding(.bottom, 10) // Add bottom padding for space
                }
            }
        }
        .navigationBarTitle("Main Page") // Set the title in the navigation bar
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
