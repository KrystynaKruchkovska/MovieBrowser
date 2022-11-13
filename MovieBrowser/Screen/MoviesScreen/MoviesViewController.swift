//
//  MoviesViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    var viewModel: MoviesViewModelProtocol?
    private let moviesTableViewHandler: MoviesTableViewHandler
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return tableView
    }()
    
    override func loadView() {
        self.view = tableView
    }

    init() {
        self.moviesTableViewHandler = MoviesTableViewHandler(tableView: self.tableView, cellReuseIdentifier: MovieCell.identifier)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getMovies()
        setupTableView()
        setupViewModel()
    }
}

extension MoviesViewController {
    private func setupTableView(){
        tableView.delegate = moviesTableViewHandler
        tableView.dataSource = moviesTableViewHandler.makeDataSource()
    }

    func setupViewModel() {
        viewModel?.didFetchMovies = { [weak self] movies in
            self?.moviesTableViewHandler.add([movies])
        }
        moviesTableViewHandler.fetchMovies = { [weak self] in
            self?.viewModel?.getMovies()
        }
    }
}
