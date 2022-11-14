//
//  MoviesListsView.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 14/11/2022.
//  
//


import UIKit

class MoviesListView: UIView {
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let progressIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .darkGray
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        return activityIndicatorView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MoviesListView {

        func setupView() {
            setupSubviews()
            setupConstraints()
        }

        func setupSubviews() {
            addSubview(tableView)
            addSubview(progressIndicator)
        }

        func setupConstraints() {
            NSLayoutConstraint.activate(
                [
                    tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    tableView.topAnchor.constraint(equalTo: topAnchor),
                    tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    progressIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                    progressIndicator.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
                ]
            )
        }
}
