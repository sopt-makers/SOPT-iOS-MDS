//
//  ColorTokenViewController.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit

final class ColorTokenViewController: UIViewController {
    private let sections = ColorTokenDataSource.sections

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 56
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Color"
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

extension ColorTokenViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColorTokenCell.reuseIdentifier, for: indexPath) as! ColorTokenCell
        cell.configure(with: sections[indexPath.section].items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
}
