//
//  MusicPLayerViewModel.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import UIKit
import Foundation
import MediaPlayer
import Combine

protocol MusicPlayerViewModelProtocol {
  func fetchTracks()
  func startPlay(trackIndex: Int)
  func pauseTrack()
}

final class MusicPlayerViewModel: MusicPlayerViewModelProtocol {
  
  // MARK: - Properties
  let deezerAPI = DeezerAPI()
  
  @Published var isLoading = false
  @Published var currentTrackIndex = 0
  @Published var maxCurrentDuration: Double = 0
  @Published var currentDuration: Double = 0
  @Published var isPlaying = false
  @Published var currentTrackName: String = ""
  @Published var currentTrackArtist: String = ""
  @Published var tracks: [Datum] = []
  
  var subscriptions = Set<AnyCancellable>()
  let musicPlayer = AVPlayer()
  
  // MARK: - Functions
  func fetchTracks() {
    isLoading = true
    deezerAPI.fetchTracks()
      .sink(
        receiveCompletion: { status in
          switch status {
          case .finished:
            print("Completed")
            break
          case .failure(let error):
            print("Receiver error \(error)")
            break
          }
        },
        receiveValue: { tracks in
          print("Data received")
          self.tracks = tracks
          self.isLoading = false
        }
      )
      .store(in: &subscriptions)
  }
  
  func searchArtistName(name: String) {
    isLoading = true
    deezerAPI.searchTracksByArtist(name: name)
      .sink(
        receiveCompletion: { status in
          switch status {
          case .finished:
            print("Completed")
            break
          case .failure(let error):
            print("Receiver error \(error)")
            break
          }
        },
        receiveValue: { tracks in
          print("Data received")
          self.tracks = tracks
          self.isLoading = false
        }
      )
      .store(in: &subscriptions)
  }
  
  func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(trackDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: musicPlayer.currentItem)
    if let duration = musicPlayer.currentItem?.asset.duration.seconds {
      self.maxCurrentDuration = duration
    }
    musicPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: DispatchQueue.main) { (time) in
      self.currentDuration = time.seconds
    }
  }
  
  @objc func trackDidEnded() {
    NotificationCenter.default.removeObserver(self)
    var newTrackIndex = currentTrackIndex
    if newTrackIndex == tracks.count - 1 {
      newTrackIndex = 0
    } else {
      newTrackIndex += 1
    }
    startPlay(trackIndex: newTrackIndex)
  }
  
  func startPlay(trackIndex: Int) {
    if currentTrackIndex == trackIndex && isPlaying == true {
      pauseTrack()
    } else {
      currentTrackIndex = trackIndex
      
      let url = URL(string: tracks[trackIndex].preview)
      let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
      currentTrackName = tracks[trackIndex].title
      currentTrackArtist = tracks[trackIndex].artist.name ?? "-"
      musicPlayer.replaceCurrentItem(with: playerItem)
      musicPlayer.play()
      isPlaying = true
      addObservers()
    }
  }
  
  func pauseTrack() {
    if musicPlayer.timeControlStatus == .playing {
      musicPlayer.pause()
      isPlaying = false
    } else if musicPlayer.timeControlStatus == .paused {
      musicPlayer.play()
      isPlaying = true
    }
  }
}
