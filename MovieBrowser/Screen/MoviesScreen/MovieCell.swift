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
        addSubview(vStackView)
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
    
    private var publishingYearLabel: UILabel = {
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
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = DefaultCellLayout.cornerRadius
        
        return imageView
    }()
    
    lazy private var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieNameLabel, publishingYearLabel, descriptionTextView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func update(title: String) {
        movieNameLabel.text = title
    }
}

extension MovieCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: self.topAnchor),
            vStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            vStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),        ])
    }
    

}

extension MovieCell: Providable {
    typealias ProvidedItem = MovieInfo
    
    func provide(_ item: ProvidedItem) {
        update(title: item.originalTitle)
    }
}
