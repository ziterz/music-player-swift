//
//  TrackViewCell.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import UIKit

class TrackViewCell: UITableViewCell {
  
  let musicPlayerViewModel = MusicPlayerViewModel()
  
  // MARK: - Views
  public lazy var trackNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(cgColor: .init(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1))
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
  
  public lazy var waveformIcon: UIButton = {
    let button = UIButton()
    button.tintColor = .systemBlue
    let image = UIImage(systemName: "waveform", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24)))
    button.setImage(image, for: .normal)
    button.imageView?.addSymbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing)
    button.isHidden = true
    
    return button
  }()
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = 0
    view.addArrangedSubview(trackNameLabel)
    view.addArrangedSubview(trackArtistLabel)
    
    return view
  }()
  
  private lazy var stackCardView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = .equalSpacing
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addArrangedSubview(stackView)
    view.addArrangedSubview(waveformIcon)
    
    return view
  }()
  
  // MARK: - Functions
  func configureCell(track: Datum) {
    self.trackNameLabel.text = track.title
    self.trackArtistLabel.text = track.artist.name
    
    self.addSubview(stackCardView)
    stackCardView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 10, right: 16))
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      trackNameLabel.textColor = .systemBlue
      waveformIcon.isHidden = false
    } else {
      trackNameLabel.textColor = UIColor(cgColor: .init(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1))
      waveformIcon.isHidden = true
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    trackNameLabel.text = nil
    trackArtistLabel.text = nil
  }
}
