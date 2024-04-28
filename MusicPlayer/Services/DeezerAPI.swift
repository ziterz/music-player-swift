//
//  DeezerAPI.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 28/04/24.
//

import Foundation
import Combine

final class DeezerAPI {
  
  func fetchTracks() -> AnyPublisher<[Datum], Error> {
    let url = URL(string: "https://api.deezer.com/search?q=the1975")!
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: Track.self, decoder: JSONDecoder())
      .map { $0.data }
      .eraseToAnyPublisher()
  }
  
  func searchTracksByArtist(name: String) -> AnyPublisher<[Datum], Error> {
    let url = URL(string: "https://api.deezer.com/search?q=\(name)")!
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: Track.self, decoder: JSONDecoder())
      .map { $0.data }
      .eraseToAnyPublisher()
  }
}
