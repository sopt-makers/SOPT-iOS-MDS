//
//  HomeViewController.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit

final class HomeViewController: UIViewController {
    private let items = ["Token", "Component"]

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 52
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MDS Catalog"
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
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCell")
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        cell = UITableViewCell(style: .default, reuseIdentifier: "HomeCell")
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch items[indexPath.row] {
        case "Token":
            navigationController?.pushViewController(TokenCategoryViewController(), animated: true)
        default:
            break
        }
    }
}
