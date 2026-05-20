//
//  IconTokenViewController.swift
//  MDSStoryBook
//
//  Created by 최주리 on 5/20/26.
//

import UIKit

final class IconTokenViewController: UIViewController {
    private let items = IconTokenDataSource.items()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 64
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Icon"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupTableView()
    }

    private func setupLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(IconTokenCell.self, forCellReuseIdentifier: IconTokenCell.reuseIdentifier)
    }
}

extension IconTokenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IconTokenCell.reuseIdentifier, for: indexPath) as! IconTokenCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}
