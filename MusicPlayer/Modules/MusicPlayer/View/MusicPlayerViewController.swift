//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import UIKit
import SnapKit
import Combine

class MusicPlayerViewController: UIViewController {
  
  // MARK: Properties
  private var subscriptions = Set<AnyCancellable>()
  
  let musicPlayerViewModel = MusicPlayerViewModel()
  
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
  }()
  
  private lazy var trackNameLabel: UILabel = {
    let label = UILabel()
    label.text = "Oh Caroline"
    label.textColor = .white
    label.font = .systemFont(ofSize: 19, weight: .semibold)
    label.textAlignment = .left
    
    return label
  }()
  
  private lazy var trackArtistLabel: UILabel = {
    let label = UILabel()
    label.text = "The 1975"
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.textAlignment = .left
    
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = 5
    view.addArrangedSubview(trackNameLabel)
    view.addArrangedSubview(trackArtistLabel)
    
    return view
  }()
  
  private lazy var playPauseButton: UIButton = {
    let button = UIButton()
    button.tintColor = .white
    let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 32)))
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  private let trackDurationSlider: UISlider = {
    let slider = UISlider()
    slider.thumbTintColor = .clear
    slider.isUserInteractionEnabled = false
    slider.minimumValue = 0
    slider.value = 0
    return slider
  } ()
  
  private lazy var stackCardView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = .equalSpacing
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addArrangedSubview(stackView)
    view.addArrangedSubview(playPauseButton)
    
    return view
  }()
  
  private lazy var cardView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
    view.layer.cornerRadius = 12
    
    view.addSubview(stackCardView)
    stackCardView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
    }
    
    view.addSubview(trackDurationSlider)
    trackDurationSlider.snp.makeConstraints { make in
      make.top.equalTo(stackCardView.snp.bottom)
      make.left.right.equalToSuperview()
      make.height.equalTo(20)
    }
    
    return view
  }()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    
    listTableView.register(TrackViewCell.self, forCellReuseIdentifier: "cell")
    listTableView.dataSource = self
    listTableView.delegate = self
    musicPlayerViewModel.loadListMusics()
    bindToViewModel()
  }
  
  // MARK: Private Methods
  private func setUI() {
    view.backgroundColor = UIColor(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1)
    
    view.addSubview(artistTextField)
    artistTextField.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      make.left.right.equalToSuperview().inset(16)
      make.height.equalTo(40)
    }
    
    view.addSubview(titleTopLabel)
    titleTopLabel.snp.makeConstraints { make in
      make.top.equalTo(artistTextField.snp.bottom).offset(40)
      make.left.right.equalToSuperview().inset(16)
    }
    
    view.addSubview(cardView)
    cardView.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.left.right.equalToSuperview().inset(16)
    }
    
    view.addSubview(listTableView)
    listTableView.snp.makeConstraints { make in
      make.top.equalTo(titleTopLabel.snp.bottom).offset(10)
      make.left.right.equalToSuperview()
      make.bottom.equalTo(cardView.snp.top)
    }
  }
  
  private func bindToViewModel() {
    musicPlayerViewModel.$isPlaying
      .sink { [weak self] state in
        guard let self = self else { return }
        let imageName = state ? "pause.fill" : "play.fill"
        let image = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40)))
        self.playPauseButton.setImage(image, for: .normal)
      }
      .store(in: &subscriptions)
    
    musicPlayerViewModel.$maxCurrentDuration
        .sink { [weak self] duration in
            self?.trackDurationSlider.maximumValue = Float(duration)
            let dateFormatter = DateFormatter()
        }
        .store(in: &subscriptions)
    
    musicPlayerViewModel.$currentDuration
        .sink { [weak self] duration in
            self?.trackDurationSlider.value = Float(duration)
            let dateFormatter = DateFormatter()
        }
        .store(in: &subscriptions)
    
    musicPlayerViewModel.$currentTrackName
      .sink { [weak self] trackName in
        self?.trackNameLabel.text = trackName
      }
      .store(in: &subscriptions)
    
    musicPlayerViewModel.$currentTrackArtist
      .sink { [weak self] trackArtist in
        self?.trackArtistLabel.text = trackArtist
      }
      .store(in: &subscriptions)
  }
}

extension MusicPlayerViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return musicPlayerViewModel.getListMusicsCount()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let trackCell = listTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrackViewCell else {
      return UITableViewCell()
    }
    let trackList = musicPlayerViewModel.getTracks()
    trackCell.configure(with: trackList[indexPath.item])
    trackCell.backgroundColor = .clear
    return trackCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    musicPlayerViewModel.startPlay(trackIndex: indexPath.row)
  }
}
