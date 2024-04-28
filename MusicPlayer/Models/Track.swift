//
//  Track.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 28/04/24.
//

import Foundation

// MARK: - Track
struct Track: Codable {
  let data: [Datum]
  let total: Int
  let next: String
}

// MARK: - Datum
struct Datum: Codable {
  let id: Int
  let title: String
  let preview: String
  let artist: Artist
  let album: Album
}

// MARK: - Album
struct Album: Codable {
  let id: Int?
  let title: String?
  let cover: String?
}

// MARK: - Artist
struct Artist: Codable {
  let id: Int?
  let name: String?
  let picture: String?
}
