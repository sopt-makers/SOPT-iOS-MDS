//
//  RadiusTokenViewController.swift
//  MDSStoryBook
//
//  Created by Codex on 5/24/26.
//

import UIKit

final class RadiusTokenViewController: UIViewController {
    private let items = RadiusTokenDataSource.items

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 52
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Radius"
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
        tableView.register(RadiusTokenCell.self, forCellReuseIdentifier: RadiusTokenCell.reuseIdentifier)
    }
}

extension RadiusTokenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RadiusTokenCell.reuseIdentifier, for: indexPath) as! RadiusTokenCell
        let item = items[indexPath.row]
        cell.configure(name: item.name, value: item.value)
        return cell
    }
}
