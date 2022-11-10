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
        self.contentView.addSubview(hStackView)
        self.contentView.backgroundColor = UIColor(named: Colors.cellBackground.rawValue)
        self.contentView.layer.cornerRadius = 16
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return self.description()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    private var movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)

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
        textView.backgroundColor = .clear
        textView.contentInset = UIEdgeInsets(top: -7, left: -5, bottom: -7, right: -5)
        return textView
    }()
    
    private var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = DefaultCellLayout.cornerRadius
        imageView.image = UIImage(named: ImageName.thumbnail.rawValue) 
        
        return imageView
    }()
    
    lazy private var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieNameLabel, releaseYearLabel, descriptionTextView, durationInfoHStackView])
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
    
    var clockIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clock"))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return imageView
    }()
    
    var spacer: UIView = {
        let spacer = UIView()
        spacer.isUserInteractionEnabled = false
        spacer.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return spacer
    }()
    
    private func update(movie: MovieInfoViewModel) {
        movieNameLabel.text = movie.title
        releaseYearLabel.text = movie.releaseDate.extractYear
        descriptionTextView.text = movie.overview
        durationInfo.text = movie.movieDuration
    }
}

extension MovieCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            hStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            hStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            hStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            movieImageView.widthAnchor.constraint(equalToConstant: 118)
        ])
    }
    

}

extension MovieCell: Providable {
    typealias ProvidedItem = MovieInfoViewModel
    
    func provide(_ item: ProvidedItem) {
        update(movie: item)
    }
}
