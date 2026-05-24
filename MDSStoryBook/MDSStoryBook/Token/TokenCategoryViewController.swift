//
//  TokenCategoryViewController.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit

final class TokenCategoryViewController: UIViewController {
    private let categories = ["Color", "Typography", "Spacing", "Radius", "Icon", "Base Color", "Base Typography"]

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 52
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Token"
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
    }
}

extension TokenCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        cell.textLabel?.text = categories[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch categories[indexPath.row] {
        case "Color":
            navigationController?.pushViewController(ColorTokenViewController(), animated: true)
        case "Typography":
            navigationController?.pushViewController(TypographyTokenViewController(), animated: true)
        case "Spacing":
            navigationController?.pushViewController(SpacingTokenViewController(), animated: true)
        case "Radius":
            navigationController?.pushViewController(RadiusTokenViewController(), animated: true)
        case "Icon":
            navigationController?.pushViewController(IconTokenViewController(), animated: true)
        case "Base Color":
            navigationController?.pushViewController(BaseColorTokenViewController(), animated: true)
        case "Base Typography":
            navigationController?.pushViewController(BaseTypographyTokenViewController(), animated: true)
        default:
            break
        }
    }
}
