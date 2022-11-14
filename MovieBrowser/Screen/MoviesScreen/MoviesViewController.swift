//
//  MoviesViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    var viewModel: MoviesViewModelProtocol?
    
    private lazy var moviesTableViewHandler: MoviesTableViewHandler = MoviesTableViewHandler(tableView: customView.tableView, cellReuseIdentifier: MovieCell.identifier)
    
    private let infoAlert: DefaultInfoAlert = DefaultInfoAlert()

    private var customView: MoviesListView {
        return view as! MoviesListView
    }
    
    override func loadView() {
        super.loadView()
        self.view = MoviesListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
        getMovies()
    }
    
    private func getMovies() {
        customView.progressIndicator.startAnimating()
        
        viewModel?.getMovies(completion: { [weak self] in
            self?.customView.progressIndicator.stopAnimating()
        })
    }
}

extension MoviesViewController {
    private func setupTableView(){
        customView.tableView.delegate = moviesTableViewHandler
        customView.tableView.dataSource = moviesTableViewHandler.makeDataSource()
    }

    private func setupViewModel() {
        viewModel?.didFetchMovie = { [weak self] movies in
            self?.moviesTableViewHandler.add([movies])
        }
        viewModel?.onError = { [unowned self] error in
            infoAlert.show(on: self, message: error.localizedDescription, acceptanceCompletion: nil)

        }
        moviesTableViewHandler.fetchMovies = { [weak self] in
            self?.getMovies()
        }
    }
}
