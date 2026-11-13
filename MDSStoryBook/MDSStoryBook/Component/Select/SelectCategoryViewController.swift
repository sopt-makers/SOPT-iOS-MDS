//
//  SelectCategoryViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class SelectCategoryViewController: UIViewController {
    private enum Category: String, CaseIterable {
        case single = "Single"
        case multiple = "Multiple"
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
        title = "Select"
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

extension SelectCategoryViewController: UITableViewDataSource, UITableViewDelegate {
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
        case .single:
            navigationController?.pushViewController(SingleSelectViewController(), animated: true)
        case .multiple:
            navigationController?.pushViewController(MultipleSelectViewController(), animated: true)
        }
    }
}

// MARK: - Helpers

extension MenuCatalogViewController {
    /// Figma 시안과 같은 160 너비로 왼쪽 정렬한다.
    func wrapSelect(_ select: MDSSelect) -> UIView {
        select.widthAnchor.constraint(equalToConstant: 160).isActive = true
        return wrapLeading(select)
    }

    /// `onSelectionChanged` 결과를 라벨에 보여준다.
    func bindSelection(_ select: MDSSelect, to label: UILabel, titles: [String]) {
        select.onSelectionChanged = { [weak label] indices in
            label?.text = "선택: \(indices.sorted().map { titles[$0] })"
        }
    }
}
