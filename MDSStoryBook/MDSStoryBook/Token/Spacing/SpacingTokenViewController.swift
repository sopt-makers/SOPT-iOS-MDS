//
//  SpacingTokenViewController.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit
import MDS

final class SpacingTokenViewController: UIViewController {
    private let items: [(name: String, value: CGFloat)] = [
        ("s0", BaseSpacing.Base.s0), ("s2", BaseSpacing.Base.s2), ("s4", BaseSpacing.Base.s4),
        ("s6", BaseSpacing.Base.s6), ("s8", BaseSpacing.Base.s8), ("s10", BaseSpacing.Base.s10),
        ("s12", BaseSpacing.Base.s12), ("s14", BaseSpacing.Base.s14), ("s16", BaseSpacing.Base.s16),
        ("s20", BaseSpacing.Base.s20), ("s24", BaseSpacing.Base.s24), ("s28", BaseSpacing.Base.s28),
        ("s32", BaseSpacing.Base.s32), ("s36", BaseSpacing.Base.s36), ("s40", BaseSpacing.Base.s40),
        ("s48", BaseSpacing.Base.s48), ("s64", BaseSpacing.Base.s64), ("s72", BaseSpacing.Base.s72),
        ("s80", BaseSpacing.Base.s80), ("s120", BaseSpacing.Base.s120), ("s160", BaseSpacing.Base.s160),
    ]

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
        cell.configure(name: item.name, value: item.value, maxValue: BaseSpacing.Base.s160)
        return cell
    }
}
