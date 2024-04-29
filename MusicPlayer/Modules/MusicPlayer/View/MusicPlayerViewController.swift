//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import UIKit
import SnapKit
import Combine

class MusicPlayerViewController: UIViewController, UISearchBarDelegate {
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  let musicPlayerViewModel = MusicPlayerViewModel()
  
  // MARK: - Views
  private let artistSearchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.searchTextField.borderStyle = .roundedRect
    searchBar.searchTextField.placeholder = "Search artist and song title"
    searchBar.backgroundImage = UIImage()
    
    return searchBar
  }()
  
  private let titleTopLabel: UILabel = {
    let label = UILabel()
    label.text = "Listen Now"
    label.textColor = .black
    label.font = .systemFont(ofSize: 26, weight: .bold)
    
    return label
  }()
  
  let listTableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.contentInset.bottom = 70
    
    return tableView
  }()
  
  private lazy var trackNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .darkGray
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textAlignment = .left
    
    return label
  }()
  
  private lazy var trackArtistLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 14, weight: .medium)
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
    let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 28)))
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  private let trackDurationSlider: UISlider = {
    let slider = UISlider()
    slider.thumbTintColor = .clear
    slider.maximumTrackTintColor = .white
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
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 12, right: 16))
    }
    
    view.addSubview(trackDurationSlider)
    trackDurationSlider.snp.makeConstraints { make in
      make.top.equalTo(stackCardView.snp.bottom).offset(-6)
      make.left.right.equalToSuperview()
    }
    
    view.clipsToBounds = true
    
    let container = UIView()
    container.layer.shadowColor = UIColor.lightGray.cgColor
    container.layer.shadowOpacity = 0.7
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
  
  // MARK: - Private Methods
  private func setUI() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(artistSearchBar)
    artistSearchBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
      make.left.right.equalToSuperview().inset(8)
    }
    
    view.addSubview(titleTopLabel)
    titleTopLabel.snp.makeConstraints { make in
      make.top.equalTo(artistSearchBar.snp.bottom).offset(18)
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
  
  private func showLoading() {
    listTableView.isHidden = true
    let alertController = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
    
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.startAnimating()
    indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    indicator.isUserInteractionEnabled = false
    
    alertController.view.snp.makeConstraints { make in
      make.height.equalTo(100)
    }
    
    alertController.view.addSubview(indicator)
    indicator.snp.makeConstraints { make in
      make.centerX.equalTo(alertController.view)
      make.top.equalTo(alertController.view.snp.centerY).offset(5)
    }
    
    present(alertController, animated: true, completion: nil)
  }
  
  private func showError(message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
      alertController.dismiss(animated: true, completion: nil)
    }
    alertController.addAction(OKAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func dismissLoading() {
    listTableView.isHidden = false
    dismiss(animated: true, completion: nil)
  }
  
  private func bindToViewModel() {
    musicPlayerViewModel.$isPlaying
      .sink { [weak self] state in
        guard let self = self else { return }
        let imageName = state ? "pause.fill" : "play.fill"
        let image = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 28)))
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
    
    musicPlayerViewModel.$tracks
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.listTableView.reloadData()
      }
      .store(in: &subscriptions)
    
    musicPlayerViewModel.$isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isLoading in
        if isLoading {
          self?.showLoading()
        } else {
          self?.dismissLoading()
        }
      }
      .store(in: &subscriptions)
  }
  
  private func addTargets() {
    playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
    artistSearchBar.delegate = self
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    musicPlayerViewModel.searchArtistName(name: searchBar.text ?? "")
    artistSearchBar.endEditing(true)
  }
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    artistSearchBar.showsCancelButton = true
    return true
  }
  
  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    artistSearchBar.showsCancelButton = false
    return true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    artistSearchBar.endEditing(true)
  }
  
  @objc private func playPauseButtonTapped() {
    musicPlayerViewModel.pauseTrack()
  }
}
