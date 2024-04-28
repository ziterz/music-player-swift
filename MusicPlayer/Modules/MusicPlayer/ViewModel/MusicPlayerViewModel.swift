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
  
  // MARK: - Properties
  let deezerAPI = DeezerAPI()
  
  @Published var currentTrackIndex = 0
  @Published var maxCurrentDuration: Double = 0
  @Published var currentDuration: Double = 0
  @Published var isPlaying = false
  @Published var currentTrackName: String = ""
  @Published var currentTrackArtist: String = ""
  
  var newTracks: [Datum] = [
    Datum(id: 1809784317, title: "About You", preview: "https://cdns-preview-6.dzcdn.net/stream/c-6c6ab6665330f0581a3c3de5585e1165-4.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(331966797), title: Optional("Being Funny In A Foreign Language"), cover: Optional("https://api.deezer.com/album/331966797/image"))),
    Datum(id: 69941970, title: "Robbers", preview: "https://cdns-preview-2.dzcdn.net/stream/c-2f923e886be75581057fe2aa215b2c24-5.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(6858831), title: Optional("The 1975"), cover: Optional("https://api.deezer.com/album/6858831/image"))),
    Datum(id: 119205662, title: "Somebody Else", preview: "https://cdns-preview-d.dzcdn.net/stream/c-d73bc6fbabbf4db71a504cc4e6ae234e-6.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(12413350), title: Optional("Somebody Else"), cover: Optional("https://api.deezer.com/album/12413350/image"))),
    Datum(id: 1809784247, title: "Looking For Somebody (To Love)", preview: "https://cdns-preview-f.dzcdn.net/stream/c-f9176961d73b15a2159b01a4d8437907-4.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(331966797), title: Optional("Being Funny In A Foreign Language"), cover: Optional("https://api.deezer.com/album/331966797/image"))),
    Datum(id: 593688972, title: "It\'s Not Living (If It\'s Not With You)", preview: "https://cdns-preview-2.dzcdn.net/stream/c-29b2b0f77cdd0f46c1046a52b1cd744e-5.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(79884272), title: Optional("A Brief Inquiry Into Online Relationships"), cover: Optional("https://api.deezer.com/album/79884272/image"))),
    Datum(id: 593688912, title: "Love It If We Made It", preview: "https://cdns-preview-b.dzcdn.net/stream/c-bf168d2213588753e5d57a7b82bded48-5.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(79884272), title: Optional("A Brief Inquiry Into Online Relationships"), cover: Optional("https://api.deezer.com/album/79884272/image"))),
    Datum(id: 118760368, title: "Fallingforyou", preview: "https://cdns-preview-3.dzcdn.net/stream/c-3731e370d081c9a2cb0e9b9681a38588-6.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(12354568), title: Optional("The 1975 (Deluxe)"), cover: Optional("https://api.deezer.com/album/12354568/image"))),
    Datum(id: 1809784277, title: "I\'m In Love With You", preview: "https://cdns-preview-0.dzcdn.net/stream/c-0a3fa948b4c3501f2ccdf05c5c852dc6-4.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(331966797), title: Optional("Being Funny In A Foreign Language"), cover: Optional("https://api.deezer.com/album/331966797/image"))),
    Datum(id: 117303522, title: "The Sound", preview: "https://cdns-preview-5.dzcdn.net/stream/c-5d7b526247f229a3918406c303862461-7.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(12174190), title: Optional("The Sound"), cover: Optional("https://api.deezer.com/album/12174190/image"))),
    Datum(id: 69941964, title: "Chocolate", preview: "https://cdns-preview-2.dzcdn.net/stream/c-2995c79bed705e96efaced9ea5c5b5be-5.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(6858831), title: Optional("The 1975"), cover: Optional("https://api.deezer.com/album/6858831/image"))),
    Datum(id: 964227052, title: "Guys", preview: "https://cdns-preview-8.dzcdn.net/stream/c-8324fd2d0b672dfa5e85dc75b97cbbc8-4.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(149040992), title: Optional("Notes On A Conditional Form"), cover: Optional("https://api.deezer.com/album/149040992/image"))),
    Datum(id: 935961222, title: "If You’re Too Shy (Let Me Know) (Edit)", preview: "https://cdns-preview-7.dzcdn.net/stream/c-74437ed300a6d2ae13f241c7eec8d16f-6.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(143089432), title: Optional("If You’re Too Shy (Let Me Know)"), cover: Optional("https://api.deezer.com/album/143089432/image"))),
    Datum(id: 1809784267, title: "Oh Caroline", preview: "https://cdns-preview-6.dzcdn.net/stream/c-68dc30de1a47e6d889d8a04d60d3e976-4.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(331966797), title: Optional("Being Funny In A Foreign Language"), cover: Optional("https://api.deezer.com/album/331966797/image"))),
    Datum(id: 964226992, title: "If You’re Too Shy (Let Me Know)", preview: "https://cdns-preview-7.dzcdn.net/stream/c-7b5ce3112bf0242905c08e6a332279b2-4.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(149040992), title: Optional("Notes On A Conditional Form"), cover: Optional("https://api.deezer.com/album/149040992/image"))),
    Datum(id: 593688892, title: "TOOTIMETOOTIMETOOTIME", preview: "https://cdns-preview-d.dzcdn.net/stream/c-d66620791f505882bae9e25be249dc22-5.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(79884272), title: Optional("A Brief Inquiry Into Online Relationships"), cover: Optional("https://api.deezer.com/album/79884272/image"))),
    Datum(id: 593689002, title: "I Couldn\'t Be More In Love", preview: "https://cdns-preview-9.dzcdn.net/stream/c-90a2635acb280a961771cee46c317540-5.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(79884272), title: Optional("A Brief Inquiry Into Online Relationships"), cover: Optional("https://api.deezer.com/album/79884272/image"))),
    Datum(id: 593688882, title: "Give Yourself A Try", preview: "https://cdns-preview-5.dzcdn.net/stream/c-585f1948b7702eea4e0c64ec7859f4c5-5.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(79884272), title: Optional("A Brief Inquiry Into Online Relationships"), cover: Optional("https://api.deezer.com/album/79884272/image"))),
    Datum(id: 119874164, title: "If I Believe You", preview: "https://cdns-preview-e.dzcdn.net/stream/c-ec2032a42ea1abfc152984088f9f3716-6.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(12494532), title: Optional("I like it when you sleep, for you are so beautiful yet so unaware of it"), cover: Optional("https://api.deezer.com/album/12494532/image"))),
    Datum(id: 119874158, title: "She\'s American", preview: "https://cdns-preview-e.dzcdn.net/stream/c-ea0aad5441d4c5a0b19d88365ff950d2-6.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(12494532), title: Optional("I like it when you sleep, for you are so beautiful yet so unaware of it"), cover: Optional("https://api.deezer.com/album/12494532/image"))),
    Datum(id: 119874222, title: "Paris", preview: "https://cdns-preview-0.dzcdn.net/stream/c-0e9c284029d804f8c68a184caf292d98-8.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(12494532), title: Optional("I like it when you sleep, for you are so beautiful yet so unaware of it"), cover: Optional("https://api.deezer.com/album/12494532/image"))),
    Datum(id: 539392652, title: "Narcissist", preview: "https://cdns-preview-a.dzcdn.net/stream/c-a6508c152dc672a7c669dd83f4f3607f-9.mp3", artist: Artist(id: Optional(9589968), name: Optional("No Rome"), picture: Optional("https://api.deezer.com/artist/9589968/image")), album: Album(id: Optional(70335162), title: Optional("RIP Indo Hisashi"), cover: Optional("https://api.deezer.com/album/70335162/image"))),
    Datum(id: 69808515, title: "Sex (Acoustic Version)", preview: "https://cdns-preview-e.dzcdn.net/stream/c-ebec4cad6f10d3302cdee04002b97eb1-3.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(6843273), title: Optional("Sex EP"), cover: Optional("https://api.deezer.com/album/6843273/image"))),
    Datum(id: 118760312, title: "Sex", preview: "https://cdns-preview-e.dzcdn.net/stream/c-eb0dd3fa66c8831b2d0da15679b5226c-7.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(12354568), title: Optional("The 1975 (Deluxe)"), cover: Optional("https://api.deezer.com/album/12354568/image"))),
    Datum(id: 1809784287, title: "All I Need To Hear", preview: "https://cdns-preview-9.dzcdn.net/stream/c-9360cd86c75c965b042101ff7d01078f-4.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(331966797), title: Optional("Being Funny In A Foreign Language"), cover: Optional("https://api.deezer.com/album/331966797/image"))),
    Datum(id: 593688932, title: "Sincerity Is Scary", preview: "https://cdns-preview-a.dzcdn.net/stream/c-a50197eb09b742ca53bf7dcbecf22d8a-5.mp3", artist: Artist(id: Optional(3583591), name: Optional("The 1975"), picture: Optional("https://api.deezer.com/artist/3583591/image")), album: Album(id: Optional(79884272), title: Optional("A Brief Inquiry Into Online Relationships"), cover: Optional("https://api.deezer.com/album/79884272/image")))
  ]
  var subscriptions = Set<AnyCancellable>()
  let musicPlayer = AVPlayer()
  
  // MARK: - Functions
  func fetchTracks() {
    deezerAPI.fetchTracks()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          print("Error: \(error)")
        }
      }, receiveValue: { [weak self]  tracks in
        guard let self = self else { return }
        
        newTracks.removeAll()
        for track in tracks {
          self.newTracks.append(Datum(id: track.id, title: track.title, preview: track.preview, artist: track.artist, album: track.album))
          print(Datum(id: track.id, title: track.title, preview: track.preview, artist: track.artist, album: track.album))
        }
      })
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
    if newTrackIndex == newTracks.count - 1 {
      newTrackIndex = 0
    } else {
      newTrackIndex += 1
    }
    startPlay(trackIndex: newTrackIndex)
  }
  
  func startPlay(trackIndex: Int) {
    if currentTrackIndex == trackIndex && isPlaying == true {
      pause()
    } else {
      currentTrackIndex = trackIndex
      
      let url = URL(string: newTracks[trackIndex].preview)
      let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
      currentTrackName = newTracks[trackIndex].title
      currentTrackArtist = newTracks[trackIndex].artist.name ?? "-"
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
  
  func getListMusicsCount() -> Int {
    newTracks.count
  }
  
  func getTracks() -> [Datum] {
    newTracks
  }
}
