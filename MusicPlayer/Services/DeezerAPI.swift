//
//  DeezerAPI.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 28/04/24.
//

import Foundation
import Combine

final class DeezerAPI {
  
  // MARK: - Functions
  func fetchTracks() -> AnyPublisher<[Datum], Error> {
    let url = URL(string: "https://api.deezer.com/artist/12246/top?limit=15")!
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { element -> Data in
        guard let response = element.response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
          throw URLError(.badServerResponse)
        }
        return element.data
      }
      .decode(type: Track.self, decoder: JSONDecoder())
      .map { $0.data }
      .eraseToAnyPublisher()
    
  }
  
  func searchTracksByArtist(name: String) -> AnyPublisher<[Datum], Error> {
    let url = URL(string: "https://api.deezer.com/search?q=\(name)")!
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { element -> Data in
        guard let response = element.response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
          throw URLError(.badServerResponse)
        }
        return element.data
      }
      .decode(type: Track.self, decoder: JSONDecoder())
      .map { $0.data }
      .eraseToAnyPublisher()
  }
}
