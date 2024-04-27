//
//  MusicViewCell.swift
//  MusicPlayer
//
//  Created by Ziady Mubaraq on 27/04/24.
//

import UIKit

class TrackViewCell: UITableViewCell {
  
  // MARK: Properties
  private lazy var trackNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 19, weight: .semibold)
    label.textAlignment = .left
    
    return label
  }()
  
  private lazy var trackArtistLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.textAlignment = .left
    
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = 4
    view.addArrangedSubview(trackNameLabel)
    view.addArrangedSubview(trackArtistLabel)
    
    return view
  }()
  
  public func configure(with data: Track) {
    self.trackNameLabel.text = data.trackName
    self.trackArtistLabel.text = data.artistName
    
    self.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
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
