//
//  GenresListView.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 15/11/2022.
//  
//


import UIKit

final class GenresListView: UIView {
    let cellId = "GenresCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
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

private extension GenresListView {

        func setupView() {
            setupSubviews()
            setupConstraints()
        }

        func setupSubviews() {
            addSubview(tableView)
            addSubview(activityIndicator)
        }

        func setupConstraints() {
            NSLayoutConstraint.activate(
                [
                    tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    tableView.topAnchor.constraint(equalTo: topAnchor),
                    tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
                ]
            )
        }
}

