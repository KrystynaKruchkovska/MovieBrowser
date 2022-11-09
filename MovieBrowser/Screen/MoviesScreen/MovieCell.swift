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
        backgroundColor = .red
        addSubview(hStackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return self.description()
    }
    
    private var movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)

        return label
    }()
    
    private var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Colors.defaultGray.rawValue)

        return label
    }()
    
    private var descriptionTextView: UITextView = {
        var textView = UITextView()
        return textView
    }()
    
    private var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = DefaultCellLayout.cornerRadius
        imageView.image = UIImage(named: "thumbnail.png")
        
        return imageView
    }()
    
    lazy private var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieNameLabel, releaseYearLabel, descriptionTextView])
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
    
    private var durationInfo: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Colors.defaultGray.rawValue)
        
        return label
    }()
    
    var clockIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: SystemSymbols.clockFill.rawValue))
        
        return imageView
    }()
    
    private func update(movie: MovieInfo) {
        movieNameLabel.text = movie.title
        releaseYearLabel.text = movie.releaseDate.extractYear
        descriptionTextView.text = movie.overview
    }
}

extension MovieCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            hStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            hStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            hStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            movieImageView.widthAnchor.constraint(equalToConstant: 118)
        ])
    }
    

}

extension MovieCell: Providable {
    typealias ProvidedItem = MovieInfo
    
    func provide(_ item: ProvidedItem) {
        update(movie: item)
    }
}
