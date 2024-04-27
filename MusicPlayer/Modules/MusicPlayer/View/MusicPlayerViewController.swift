//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import UIKit

class MusicPlayerViewController: UIViewController {
  
  // MARK: Properties
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
    view.addArrangedSubview(trackNameLabel)
    view.addArrangedSubview(trackArtistLabel)
    
    return view
  }()
  
  private let playPauseButton: UIButton = {
    let button = UIButton()
    button.tintColor = .white
    let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 32)))
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
  }
  
  // MARK: Private Methods
  private func setUI() {
    view.backgroundColor = UIColor(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1)
    
    view.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    
    view.addSubview(playPauseButton)
    playPauseButton.snp.makeConstraints { make in
      make.right.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
  }
}
