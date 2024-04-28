//
//  MusicViewCell.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import UIKit

class TrackViewCell: UITableViewCell {
  
  // MARK: Properties
  public lazy var trackNameLabel: UILabel = {
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
  
  public lazy var playPauseButton: UIButton = {
    let button = UIButton()
    button.tintColor = .systemBlue
    let image = UIImage(systemName: "waveform", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 28)))
    button.setImage(image, for: .normal)
    button.imageView?.addSymbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing)
    button.isHidden = true
    
    return button
  }()
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = 4
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
    view.addArrangedSubview(playPauseButton)
    
    return view
  }()
  
  public func configure(with data: Datum) {
    self.trackNameLabel.text = data.title
    self.trackArtistLabel.text = data.artist.name
    
    self.addSubview(stackCardView)
    stackCardView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 15, right: 16))
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    trackNameLabel.text = nil
    trackArtistLabel.text = nil
  }
}
