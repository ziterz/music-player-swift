//
//  MusicPlayerViewController + TableView.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 28/04/24.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MusicPlayerViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return musicPlayerViewModel.newTracks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let trackCell = listTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrackViewCell else {
      return UITableViewCell()
    }
    let trackList = musicPlayerViewModel.newTracks
    trackCell.configure(with: trackList[indexPath.item])
    
    let backgroundView = UIView()
    backgroundView.backgroundColor = .systemGray6
    trackCell.selectedBackgroundView = backgroundView
    
    return trackCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    cardView.isHidden = false
    musicPlayerViewModel.startPlay(trackIndex: indexPath.row)
  }
}
