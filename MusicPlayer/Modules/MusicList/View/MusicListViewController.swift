//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import UIKit
import SnapKit

class MusicListViewController: UIViewController {
  
  // MARK: Properties
  private var tracks: [Track] = [
    Track(trackName: "About You", artistName: "The 1975", trackURL: "", trackPoster: ""),
    Track(trackName: "Oh Caroline", artistName: "The 1975", trackURL: "", trackPoster: "")
  ]
  
  private let artistTextField: UITextField = {
    let view = UITextField()
    view.placeholder = "Search artist"
    view.backgroundColor = .white
    view.borderStyle = .roundedRect
    
    return view
  }()
  
  private let titleTopLabel: UILabel = {
    let label = UILabel()
    label.text = "Today's Top Hits"
    label.textColor = .white
    label.font = .systemFont(ofSize: 24, weight: .bold)
    
    return label
  }()
  
  private let listTableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    
    return tableView
  } ()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    listTableView.register(TrackViewCell.self, forCellReuseIdentifier: "cell")
    listTableView.dataSource = self
    listTableView.delegate = self
  }
  
  // MARK: Private Methods
  private func setUI() {
    view.backgroundColor = UIColor(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1)
    
    view.addSubview(artistTextField)
    artistTextField.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      make.left.right.equalToSuperview().inset(30)
      make.height.equalTo(40)
    }
    
    view.addSubview(titleTopLabel)
    titleTopLabel.snp.makeConstraints { make in
      make.top.equalTo(artistTextField.snp.bottom).offset(40)
      make.left.right.equalToSuperview().inset(16)
    }
    
    view.addSubview(listTableView)
    listTableView.snp.makeConstraints { make in
      make.top.equalTo(titleTopLabel.snp.bottom).offset(10)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

extension MusicListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tracks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let trackCell = listTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrackViewCell else {
      return UITableViewCell()
    }
    trackCell.configure(with: tracks[indexPath.item])
    trackCell.backgroundColor = .clear
    return trackCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}
