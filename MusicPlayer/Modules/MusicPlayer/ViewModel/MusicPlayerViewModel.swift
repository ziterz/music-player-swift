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
  func getListMusicsCount() -> Int
  func getTracks() -> [Datum]
  func startPlay(trackIndex: Int)
  func pauseTrack()
}

final class MusicPlayerViewModel: MusicPlayerViewModelProtocol {
  
  //MARK: Properties
  @Published var currentDuration: Double = 0
  @Published var maxCurrentDuration: Double = 0
  @Published var currentTrackName: String = ""
  @Published var currentTrackArtist: String = ""
  @Published var isPlaying: Bool = false
  
  private var subscriptions = Set<AnyCancellable>()
  
  func startPlay(trackIndex: Int) {
    MusicService.shared.play(trackIndex: trackIndex)
    addObservers()
  }
  
  func pauseTrack() {
    MusicService.shared.pause()
  }
  
  //MARK: - Functions
  func fetchTracks() {
    MusicService.shared.fetchTracks()
  }
  
  func getListMusicsCount() -> Int {
    MusicService.shared.newTracks.count
  }
  
  func getTracks() -> [Datum] {
    MusicService.shared.newTracks
  }
  
  // MARK: - Private functions
  private func addObservers() {
    MusicService.shared.$isPlaying
      .sink { [weak self] state in
        self?.isPlaying = state
      }
      .store(in: &subscriptions)
    
    MusicService.shared.$currentTrackIndex
      .sink { [weak self] index in
        self?.currentTrackName = MusicService.shared.newTracks[index].title
        self?.currentTrackArtist = MusicService.shared.newTracks[index].artist.name ?? "-"
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
