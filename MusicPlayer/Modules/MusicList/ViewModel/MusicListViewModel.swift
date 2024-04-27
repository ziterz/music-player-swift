//
//  MusicListViewModel.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import Foundation
import MediaPlayer

protocol MusicListViewModelProtocol {
  func loadListMusics()
  func getListMusicsCount() -> Int
  func getTracks() -> [Track]
}

final class MusicListViewModel: MusicListViewModelProtocol {
  
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
}
