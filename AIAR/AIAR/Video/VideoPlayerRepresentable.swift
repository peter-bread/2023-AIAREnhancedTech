//
//  VideoPlayerRepresentable.swift
//  AIAR
//
//  Created by Peter Sheehan on 16/03/2024.
//  (This code was originally written by Zak Mansuri)
//

import SwiftUI
import AVKit

/// Representable to display a video.
struct VideoPlayerRepresentable: UIViewRepresentable {
    
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
