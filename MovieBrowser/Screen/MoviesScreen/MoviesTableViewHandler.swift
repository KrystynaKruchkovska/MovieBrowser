//
//  TableCollectionViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 09/11/2022.
//  
//


import UIKit

class MoviesTableViewHandler: TableViewDiffableDataSourceViewModel<MovieCell> {
    private enum Constants {
        static let rowHeight: CGFloat = 219
        static let distanceFromBottom = 10.0
    }
    // Outputs
    var fetchMovies: ( () -> () )?

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= Constants.distanceFromBottom {
            fetchMovies?()
        }
    }
}

extension MoviesTableViewHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}
