//
//  BaseColorTokenViewController.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/17/26.
//

import UIKit
@_spi(MDSCatalog) import MDS

final class BaseColorTokenViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 52
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Base Color"
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
        tableView.register(ColorTokenCell.self, forCellReuseIdentifier: ColorTokenCell.reuseIdentifier)
    }
}

extension BaseColorTokenViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        BaseColorCatalogData.groups.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        BaseColorCatalogData.groups[section].paletteName
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BaseColorCatalogData.groups[section].entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColorTokenCell.reuseIdentifier, for: indexPath) as! ColorTokenCell
        let entry = BaseColorCatalogData.groups[indexPath.section].entries[indexPath.row]
        cell.configure(with: ColorTokenItem(name: entry.name, color: entry.color, baseTokenPath: ""))
        return cell
    }
}
