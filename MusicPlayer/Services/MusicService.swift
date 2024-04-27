//
//  MusicService.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import Foundation
import MediaPlayer

protocol MusicServiceProtocol {
  func play(trackIndex: Int)
  func pause()
  func loadMusic()
}

final class MusicService: MusicServiceProtocol {
  
  // MARK: Properties
  static let shared = MusicService()
  
  @Published var currentTrackIndex = 0
  @Published var maxCurrentDuration: Double = 0
  @Published var currentDuration: Double = 0
  @Published var isPlaying = false
  
  var newTracks: [Track] = []
  let musicPlayer = AVPlayer()
  
  // MARK: Functions
  func play(trackIndex: Int){
    if currentTrackIndex == trackIndex && isPlaying == true {
      pause()
    } else {
      currentTrackIndex = trackIndex
      let playerItem = AVPlayerItem(url: URL(fileURLWithPath: newTracks[trackIndex].trackURL))
      musicPlayer.replaceCurrentItem(with: playerItem)
      musicPlayer.play()
      isPlaying = true
      addObservers()
    }
  }
  
  func pause() {
    if musicPlayer.timeControlStatus == .playing {
      musicPlayer.pause()
      isPlaying = false
    } else if musicPlayer.timeControlStatus == .paused {
      musicPlayer.play()
      isPlaying = true
    }
  }
  
  func loadMusic() {
    let audioFileNames = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)
    if !audioFileNames.isEmpty {
      for audioUrl in audioFileNames {
        let avp = AVPlayerItem(url: URL(fileURLWithPath: audioUrl))
        let commonMetaData = avp.asset.commonMetadata
        var title: String = ""
        var artist: String = ""
        for item in commonMetaData {
          if let key = item.commonKey?.rawValue, let value = item.stringValue {
            if key == "title" { title = value }
            if key == "artist" { artist = value }
          }
        }
        newTracks.append(Track(trackName: title, artistName: artist, trackURL: audioUrl, trackPoster: ""))
      }
    }
  }
  
  func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(trackDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: musicPlayer.currentItem)
    if let duration = MusicService.shared.musicPlayer.currentItem?.asset.duration.seconds {
      self.maxCurrentDuration = duration
    }
    musicPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: DispatchQueue.main) { (time) in
      self.currentDuration = time.seconds
    }
  }
  
  @objc func trackDidEnded() {
    NotificationCenter.default.removeObserver(self)
    var newTrackIndex = currentTrackIndex
    if newTrackIndex == newTracks.count - 1 {
      newTrackIndex = 0
    } else {
      newTrackIndex += 1
    }
    play(trackIndex: newTrackIndex)
  }
}
