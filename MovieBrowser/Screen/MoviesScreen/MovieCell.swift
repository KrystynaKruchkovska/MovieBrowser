//
//  MovieCell.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 09/11/2022.
//  
//

import UIKit

class MovieCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return self.description()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    private var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    private var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Colors.defaultGray.rawValue)
        label.font = UIFont.systemFont(ofSize: 11)
        
        return label
    }()
    
    private var descriptionTextView: UITextView = {
        var textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.contentInset = UIEdgeInsets(top: -7, left: -5, bottom: -7, right: -5)
        return textView
    }()
    
    private var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image  = UIImage(named: ImageName.thumbnail.rawValue)
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 13
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieTitleLabel, releaseYearLabel, descriptionTextView, durationInfoHStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    lazy private var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieImageView, vStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 13
        return stackView
    }()
    
    lazy private var durationInfoHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [clockIcon, durationInfo, spacer])
        stackView.spacing = 13
        stackView.alignment = .bottom
        return stackView
    }()
    
    private var durationInfo: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Colors.defaultGray.rawValue)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private var clockIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clock"))
        imageView.contentMode = .scaleAspectFit
        
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return imageView
    }()
    
    private var spacer: UIView = {
        let spacer = UIView()
        spacer.isUserInteractionEnabled = false
        spacer.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return spacer
    }()
    
    private func update(movie: MovieCellViewModel) {
        movieTitleLabel.text = movie.title
        releaseYearLabel.text = movie.releaseDate.extractYear
        descriptionTextView.text = movie.overview
        durationInfo.text = movie.movieDuration
        movie.getPosterImage { image in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self.movieImageView.fadeOut()
                self.movieImageView.image = image
                self.movieImageView.fadeIn()
            }
        }
    }
}

extension MovieCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            hStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            hStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            hStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            movieImageView.widthAnchor.constraint(equalToConstant: 118)
        ])
    }
    
    private func setupContentView() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor(named: Colors.cellBackground.rawValue)
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.shadowColor = UIColor(named: Colors.cellShadow.rawValue)?.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0,
                                          height: 6)
        self.contentView.layer.shadowRadius = 10
        self.contentView.layer.shadowOpacity = 0.13
        self.contentView.addSubview(hStackView)
    }
}

extension MovieCell: Providable {
    typealias ProvidedItem = MovieCellViewModel
    
    func provide(_ item: ProvidedItem) {
        update(movie: item)
    }
}
