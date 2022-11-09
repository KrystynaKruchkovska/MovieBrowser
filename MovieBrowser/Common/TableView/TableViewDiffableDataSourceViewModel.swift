//
//  TableViewModel.swift
//  MovieBrowser
//
//  Created by Krystyna Kruchkovska on 09/11/2022.
//  
//


import UIKit

class TableViewDiffableDataSourceViewModel<CellType: UITableViewCell & Providable>: NSObject {
    enum Section {
      case main
    }
    
    typealias Item = CellType.ProvidedItem
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    
    private var dataSource: DataSource?
    private var cellIdentifier: String
    private weak var tableView: UITableView?
//    weak var parentVC: UIViewController?
    
    public var items: Binding<[Item]> = .init([])
    
    init(tableView: UITableView, cellReuseIdentifier: String) {
        self.cellIdentifier = cellReuseIdentifier
        self.tableView = tableView
//        self.parentVC = parentVC
        super.init()
    }
}

extension TableViewDiffableDataSourceViewModel {
    private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CellType
        cell.provide(item)
        return cell
    }
    
    public func makeDataSource() -> DataSource {
        guard let tableView = tableView else { fatalError("tableView isn't here :(") }
        let dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
        self.dataSource = dataSource
        return dataSource
    }
}

extension TableViewDiffableDataSourceViewModel {
    private func update() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.value)
        dataSource?.apply(snapshot)
    }
    
    public func add(_ items: [Item]) {
        items.forEach {
            self.items.value.append($0)
        }
        update()
    }
}
