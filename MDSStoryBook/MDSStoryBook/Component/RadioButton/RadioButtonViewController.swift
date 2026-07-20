//
//  RadioButtonViewController.swift
//  MDSStoryBook
//
//  Created by yungu0010 on 6/25/26.
//

import UIKit
import MDS

final class RadioButtonViewController: UIViewController {

    private var radioGroups: [MDSRadioGroup] = []

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 32
        view.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Radio Button"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupContent()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func setupContent() {
        contentStack.addArrangedSubview(makeSection(title: "Horizontal", axis: .horizontal))
        contentStack.addArrangedSubview(makeSection(title: "Vertical", axis: .vertical))
    }
}

// MARK: - Section Builders

private extension RadioButtonViewController {

    func makeSection(title: String, axis: NSLayoutConstraint.Axis) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 20, weight: .bold)
        sectionTitle.textColor = .label

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 10
        sectionStack.addArrangedSubview(sectionTitle)
        sectionStack.addArrangedSubview(makeRow(label: "Small", size: .small, axis: axis))
        sectionStack.addArrangedSubview(makeRow(label: "Large", size: .large, axis: axis))

        return sectionStack
    }

    func makeRow(label: String, size: MDSRadioButton.Size, axis: NSLayoutConstraint.Axis) -> UIView {
        let rowLabel = UILabel()
        rowLabel.text = label
        rowLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        rowLabel.textColor = .secondaryLabel

        let buttons: [MDSRadioButton] = ["Option 1", "Option 2", "Option 3", "Option 4"].enumerated().map { index, text in
            let button = MDSRadioButton(size: size)
            button.labelText = text
            button.isEnabled = index < 2
            return button
        }
        buttons[0].isSelected = true
        buttons[3].isSelected = true

        let group = MDSRadioGroup()
        group.add(buttons)
        radioGroups.append(group)

        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 6
        rowStack.addArrangedSubview(rowLabel)
        rowStack.addArrangedSubview(makeCard(buttons: buttons, axis: axis))

        return rowStack
    }

    func makeCard(buttons: [MDSRadioButton], axis: NSLayoutConstraint.Axis) -> UIView {
        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        // Horizontal 섹션은 옵션 4개를 한 줄에 다 놓으면 좁은 화면에서 넘칠 수 있어 2x2로 감싼다.
        let buttonStack: UIStackView = axis == .horizontal
            ? makeGrid(buttons: buttons, columns: 2)
            : makeColumn(buttons: buttons)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.isLayoutMarginsRelativeArrangement = true
        buttonStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        card.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: card.topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            buttonStack.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor),
        ])

        return card
    }

    func makeColumn(buttons: [MDSRadioButton]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .leading
        return stack
    }

    func makeGrid(buttons: [MDSRadioButton], columns: Int) -> UIStackView {
        let rowsStack = UIStackView()
        rowsStack.axis = .vertical
        rowsStack.spacing = 12
        rowsStack.alignment = .leading

        for start in stride(from: 0, to: buttons.count, by: columns) {
            let rowButtons = Array(buttons[start..<min(start + columns, buttons.count)])
            let rowStack = UIStackView(arrangedSubviews: rowButtons)
            rowStack.axis = .horizontal
            rowStack.spacing = 20
            rowStack.alignment = .leading
            rowsStack.addArrangedSubview(rowStack)
        }

        return rowsStack
    }
}
