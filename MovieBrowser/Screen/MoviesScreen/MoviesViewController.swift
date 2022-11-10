//
//  MoviesViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    private (set) var viewModel: MoviesViewModelProtocol
    private let tableViewViewModel: MovieTableViewModel
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return tableView
    }()
    
    override func loadView() {
        self.view = tableView
    }

    init(viewModel: MoviesViewModelProtocol) {
        self.viewModel = viewModel
        self.tableViewViewModel = MovieTableViewModel(tableView: self.tableView, cellReuseIdentifier: MovieCell.identifier)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllMovies()
        setupTableView()
        setupViewModel()
    }
}

extension MoviesViewController {
    private func setupTableView(){
        tableView.delegate = tableViewViewModel
        tableView.dataSource = tableViewViewModel.makeDataSource()
    }

    func setupViewModel() {
        viewModel.didFetchMovies = { [weak self] movies in
            self?.tableViewViewModel.add(movies)
        }
    }
}
