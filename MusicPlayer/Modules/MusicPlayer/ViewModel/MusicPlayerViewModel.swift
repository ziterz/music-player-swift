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
  func loadListMusics()
  func getListMusicsCount() -> Int
  func getTracks() -> [Track]
}

final class MusicPlayerViewModel: MusicPlayerViewModelProtocol {
  
  //MARK: Properties
  @Published var currentDuration: Double = 0
  @Published var maxCurrentDuration: Double = 0
  @Published var currentTrackName: String = ""
  @Published var currentTrackArtist: String = ""
  @Published var isPlaying: Bool = false
  
  private var subscriptions = Set<AnyCancellable>()
  
  //MARK: Functions
  func loadListMusics() {
    MusicService.shared.loadMusic()
  }
  
  func getListMusicsCount() -> Int {
    MusicService.shared.newTracks.count
  }
  
  func getTracks() -> [Track] {
    MusicService.shared.newTracks
  }
  
  func startPlay(trackIndex: Int) {
      MusicService.shared.play(trackIndex: trackIndex)
    addObservers()
  }
  
  func pauseTrack() {
      MusicService.shared.pause()
  }
  
  // MARK: Private functions
  private func addObservers() {
    MusicService.shared.$isPlaying
      .sink { [weak self] state in
        self?.isPlaying = state
      }
      .store(in: &subscriptions)
    
    MusicService.shared.$currentTrackIndex
      .sink { [weak self] index in
        self?.currentTrackName = MusicService.shared.newTracks[index].trackName
        self?.currentTrackArtist = MusicService.shared.newTracks[index].artistName
      }
      .store(in: &subscriptions)
    
    MusicService.shared.$maxCurrentDuration
      .sink { [weak self] duration in
        self?.maxCurrentDuration = duration
      }
      .store(in: &subscriptions)
    
    MusicService.shared.$currentDuration
      .sink { [weak self] duration in
        self?.currentDuration = duration
      }
      .store(in: &subscriptions)
  }
}
