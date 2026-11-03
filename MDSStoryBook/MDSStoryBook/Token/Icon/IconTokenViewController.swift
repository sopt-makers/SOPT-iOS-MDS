//
//  IconTokenViewController.swift
//  MDSStoryBook
//
//  Created by 최주리 on 5/20/26.
//

import UIKit

final class IconTokenViewController: UIViewController {
    private let sections = IconTokenDataSource.sections()
    
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
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IconTokenCell.reuseIdentifier, for: indexPath) as! IconTokenCell
        cell.configure(with: sections[indexPath.section].items[indexPath.row])
        return cell
    }
}
