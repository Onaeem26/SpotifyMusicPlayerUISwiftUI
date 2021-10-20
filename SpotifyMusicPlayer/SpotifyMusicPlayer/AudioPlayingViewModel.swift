//
//  AudioPlayingViewModel.swift
//  SpotifyMusicPlayer
//
//  Created by Muhammad Osama Naeem on 10/17/21.
//

import SwiftUI
import Combine
import AVKit

class NowPlayingViewModel: ObservableObject {
     var player: AVAudioPlayer!
    @Published var durationTime : Int = 0
    
    init() {}
    
    public func setupAudio(musicFileName: String) {
        guard let data = NSDataAsset(name: musicFileName)?.data else {
                print("Error")
                return
            }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)


                player = try AVAudioPlayer(data: data)
                self.durationTime = Int(player.duration)

            } catch let error {
                print(error.localizedDescription)
            }
    }
    public func playAudio() {
        guard let player = player else { return }
        player.play()
    }
    
    public func pauseAudio() {
        guard let player = player else { return }
        player.pause()
    }
}
