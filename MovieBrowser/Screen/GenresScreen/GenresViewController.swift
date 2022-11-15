//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class GenresViewController: UIViewController {
    
    var viewModel: GenresViewModelProtocol?
    private var genres = [Genre]()
    private let infoAlert = DefaultInfoAlert()
    private var customView: GenresListView {
        return view as! GenresListView
    }
    override func loadView() {
        super.loadView()
        self.view = GenresListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        getGenres()
        setupViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func prepareTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
    }
    
    private func getGenres() {
        customView.activityIndicator.startAnimating()
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
    private func setupViewModel() {
        viewModel?.didFetchGeners = { [weak self] generes in
            self?.genres = generes
            self?.customView.tableView.reloadData()
            self?.customView.activityIndicator.stopAnimating()
        }
        viewModel?.onError = { [weak self] error in
            guard let self = self else {
                return
            }
            self.infoAlert.show(on: self, message: error.localizedDescription, acceptanceCompletion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: customView.cellId, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = genres[indexPath.row].name
        cell.contentConfiguration = configuration
        return cell
    }
}
