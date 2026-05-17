//
//  BaseTypographyTokenViewController.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/17/26.
//

import UIKit
@_spi(MDSCatalog) import MDS

final class BaseTypographyTokenViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Base Typography"
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
        tableView.register(TypographyTokenCell.self, forCellReuseIdentifier: TypographyTokenCell.reuseIdentifier)
    }

    private func formattedValue(_ value: CGFloat, category: String) -> String {
        switch category {
        case "weight":        return "\(Int(value))"
        case "letterSpacing": return "\(value)%"
        default:              return "\(Int(value))px"
        }
    }
}

extension BaseTypographyTokenViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        BaseTypographyCatalogData.groups.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        BaseTypographyCatalogData.groups[section].categoryName
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BaseTypographyCatalogData.groups[section].entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TypographyTokenCell.reuseIdentifier, for: indexPath) as! TypographyTokenCell
        let group = BaseTypographyCatalogData.groups[indexPath.section]
        let entry = group.entries[indexPath.row]
        cell.configure(name: entry.name, value: formattedValue(entry.value, category: group.categoryName))
        return cell
    }
}
