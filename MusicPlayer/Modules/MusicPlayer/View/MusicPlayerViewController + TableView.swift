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
    if musicPlayerViewModel.tracks.count == 0 {
      tableView.setEmptyView(title: "Song list not available", message: "Try searching again using a different spelling or keyword")
    } else {
      tableView.restore()
    }
    return musicPlayerViewModel.tracks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let trackCell = listTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrackViewCell else {
      return UITableViewCell()
    }
    let trackList = musicPlayerViewModel.tracks
    trackCell.configureCell(track: trackList[indexPath.row])
    
    let backgroundView = UIView()
    backgroundView.backgroundColor = .systemGray6
    trackCell.selectedBackgroundView = backgroundView
    
    return trackCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    cardView.isHidden = false
    musicPlayerViewModel.startPlay(trackIndex: indexPath.row)
  }
  
}

// MARK: - UITableView
extension UITableView {
  func setEmptyView(title: String, message: String) {
    let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
    
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    emptyView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalTo(emptyView.snp.centerX)
      make.centerY.equalTo(emptyView.snp.centerY).offset(-80)
    }
    titleLabel.text = title
    titleLabel.textAlignment = .center
    titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    
    let messageLabel = UILabel()
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    emptyView.addSubview(messageLabel)
    messageLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(6)
      make.left.right.equalToSuperview().inset(32)
    }
    messageLabel.text = message
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0
    messageLabel.font = .systemFont(ofSize: 14, weight: .regular)
    
    self.backgroundView = emptyView
    self.separatorStyle = .none
  }
  
  func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
  }
}
