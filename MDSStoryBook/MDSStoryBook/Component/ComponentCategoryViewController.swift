//
//  ComponentCategoryViewController.swift
//  MDSStoryBook
//

import UIKit

final class ComponentCategoryViewController: UIViewController {
    private enum Category: String, CaseIterable {
        case avatar = "Avatar"
        case chip = "Chip"
        case tag = "Tag"
        case callout = "Callout"
        case button = "Button"
        case control = "Control"
        case input = "Input"
        case dialog = "Dialog"
    }


    private let categories = Category.allCases

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 52
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Component"
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

extension ComponentCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch categories[indexPath.row] {
        case .avatar:
            navigationController?.pushViewController(AvatarViewController(), animated: true)
        case .chip:
            navigationController?.pushViewController(ChipViewController(), animated: true)
        case .tag:
            navigationController?.pushViewController(TagViewController(), animated: true)
        case .callout:
            navigationController?.pushViewController(CalloutViewController(), animated: true)
        case .button:
            navigationController?.pushViewController(ButtonCategoryViewController(), animated: true)
        case .control:
            navigationController?.pushViewController(ControlCategoryViewController(), animated: true)
        case .input:
            navigationController?.pushViewController(InputCategoryViewController(), animated: true)
        case .dialog:
            navigationController?.pushViewController(DialogViewController(), animated: true)
        }
    }
}
