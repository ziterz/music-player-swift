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
  
  // MARK: - Properties
  let musicPlayerViewModel = MusicPlayerViewModel()
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Views
  private let artistTextField: UITextField = {
    let view = UITextField()
    view.placeholder = "Search artist"
    view.backgroundColor = .systemGray6
    view.borderStyle = .roundedRect
    
    return view
  }()
  
  private let titleTopLabel: UILabel = {
    let label = UILabel()
    label.text = "Listen Now"
    label.textColor = .black
    label.font = .systemFont(ofSize: 28, weight: .bold)
    
    return label
  }()
  
  let listTableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    
    return tableView
  }()
  
  private lazy var trackNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 18, weight: .medium)
    label.textAlignment = .left
    
    return label
  }()
  
  private lazy var trackArtistLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 15, weight: .medium)
    label.textAlignment = .left
    
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = 0
    view.addArrangedSubview(trackNameLabel)
    view.addArrangedSubview(trackArtistLabel)
    
    return view
  }()
  
  private lazy var playPauseButton: UIButton = {
    let button = UIButton()
    button.tintColor = .black
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
  
  lazy var cardView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 12
    
    view.addSubview(stackCardView)
    stackCardView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 15, right: 16))
    }
    
    view.addSubview(trackDurationSlider)
    trackDurationSlider.snp.makeConstraints { make in
      make.top.equalTo(stackCardView.snp.bottom).offset(-3)
      make.left.right.equalToSuperview()
    }
    
    view.clipsToBounds = true
    
    let container = UIView()
    container.layer.shadowColor = UIColor.lightGray.cgColor
    container.layer.shadowOpacity = 0.5
    container.layer.shadowOffset = .zero
    container.layer.shadowRadius = 10
    container.addSubview(view)
    view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    container.isHidden = true
    
    return container
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    listTableView.register(TrackViewCell.self, forCellReuseIdentifier: "cell")
    listTableView.dataSource = self
    listTableView.delegate = self
    musicPlayerViewModel.fetchTracks()
    addTargets()
    bindToViewModel()
  }
  
  // MARK: Private Methods
  private func setUI() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(artistTextField)
    artistTextField.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
      make.left.right.equalToSuperview().inset(16)
      make.height.equalTo(40)
    }
    
    view.addSubview(titleTopLabel)
    titleTopLabel.snp.makeConstraints { make in
      make.top.equalTo(artistTextField.snp.bottom).offset(28)
      make.left.right.equalToSuperview().inset(16)
    }
    
    view.addSubview(listTableView)
    listTableView.snp.makeConstraints { make in
      make.top.equalTo(titleTopLabel.snp.bottom).offset(10)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    view.addSubview(cardView)
    cardView.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide)
      make.left.equalToSuperview().offset(16)
      make.right.equalToSuperview().offset(-16)
    }
  }
  
  private func bindToViewModel() {
    musicPlayerViewModel.$isPlaying
      .sink { [weak self] state in
        guard let self = self else { return }
        let imageName = state ? "pause.fill" : "play.fill"
        let image = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 32)))
        playPauseButton.setImage(image, for: .normal)
      }
      .store(in: &subscriptions)
    
    musicPlayerViewModel.$maxCurrentDuration
      .sink { [weak self] duration in
        self?.trackDurationSlider.maximumValue = Float(duration)
      }
      .store(in: &subscriptions)
    
    musicPlayerViewModel.$currentDuration
      .sink { [weak self] duration in
        self?.trackDurationSlider.value = Float(duration)
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
  
  private func addTargets() {
    playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
  }
  
  @objc private func playPauseButtonTapped() {
    musicPlayerViewModel.pauseTrack()
  }
}
