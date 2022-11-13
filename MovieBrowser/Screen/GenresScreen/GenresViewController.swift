//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class GenresViewController: UIViewController {
    private enum Constants {
        static let cellId = "GenresCell"
        static let title = "Genres"
    }

    var viewModel: GenresViewModel?
    private var genres = [Genre]()
    private let activityIndicator = UIActivityIndicatorView()

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        return tableView
    }()
    

    
    override func loadView() {
        super.loadView()
        self.view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        getGenres()
        setupViewModel()
    }

    private func prepareUI() {
        prepareRootView()
        prepareTableView()
        prepareActivityIndicator()
    }

    private func prepareRootView() {
        title = Constants.title
    }

    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func prepareActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.hidesWhenStopped = true
    }

    private func getGenres() {
        activityIndicator.startAnimating()
        viewModel?.getAllGenres()
    }
    
    private func showMoviesViewController(with genre: Genre ) {
        let moviesScene = MoviesSceneFactory()
        moviesScene.configurator = MovieSceneConfigurator(genre: genre)
        let scene = moviesScene.makeScene()
        navigationController?.pushViewController(scene, animated: true)
    }
}

extension GenresViewController {
    func setupViewModel() {
        viewModel?.didFetchGeners = { [weak self] generes in
                self?.genres = generes
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
        }
    }
}

extension GenresViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        showMoviesViewController(with: genres[indexPath.row])
    }
}

extension GenresViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = genres[indexPath.row].name
        cell.contentConfiguration = configuration
        return cell
    }
}
