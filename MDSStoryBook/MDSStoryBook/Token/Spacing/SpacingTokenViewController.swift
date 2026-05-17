//
//  SpacingTokenViewController.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit
import MDS

final class SpacingTokenViewController: UIViewController {
    private let items = SpacingTokenDataSource.items

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 52
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spacing"
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
        tableView.register(SpacingTokenCell.self, forCellReuseIdentifier: SpacingTokenCell.reuseIdentifier)
    }
}

extension SpacingTokenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpacingTokenCell.reuseIdentifier, for: indexPath) as! SpacingTokenCell
        let item = items[indexPath.row]
        cell.configure(name: item.name, value: item.value, maxValue: SpacingTokenDataSource.items.last?.value ?? 0)
        return cell
    }
}
