//
//  DialogViewController.swift
//  MDSStoryBook
//
//  Created by 최주리 on 7/6/26.
//

import UIKit
import MDS

final class DialogViewController: UIViewController {

    private var dialogs: [MDSDialog] = []

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
        title = "Dialog"
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
        contentStack.addArrangedSubview(makeSection(title: "Default", makeVariant: {
            .default(primaryButtonTitle: "Button", disableButtonTitle: "Button")
        }))
        contentStack.addArrangedSubview(makeSection(title: "Information", makeVariant: {
            .information(primaryButtonTitle: "Button")
        }))
        contentStack.addArrangedSubview(makeSection(title: "Danger", makeVariant: {
            .danger(primaryButtonTitle: "Button", disableButtonTitle: "Button")
        }))
    }
}

// MARK: - Section Builders

private extension DialogViewController {

    func makeSection(title: String, makeVariant: () -> MDSDialog.Variant) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 20, weight: .bold)
        sectionTitle.textColor = .label

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 10
        sectionStack.addArrangedSubview(sectionTitle)
        sectionStack.addArrangedSubview(makeRow(label: "No Checkbox", variant: makeVariant(), hasCheckbox: false))
        sectionStack.addArrangedSubview(makeRow(label: "With Checkbox", variant: makeVariant(), hasCheckbox: true))

        return sectionStack
    }

    func makeRow(label: String, variant: MDSDialog.Variant, hasCheckbox: Bool) -> UIView {
        let rowLabel = UILabel()
        rowLabel.text = label
        rowLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        rowLabel.textColor = .secondaryLabel
        
        var checkBox: MDSCheckbox? = nil
        if hasCheckbox {
            checkBox = MDSCheckbox(size: .small, title: "check box")
        }

        let dialog = MDSDialog(
            variant: variant,
            title: "Title Text",
            description: "Description Text\nDescription Text",
            checkbox: checkBox
        )
        dialog.onPrimaryTap = { print("\(label) - primary tapped") }
        dialog.onSecondaryTap = { print("\(label) - secondary tapped") }
        dialogs.append(dialog)

        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 6
        rowStack.addArrangedSubview(rowLabel)
        rowStack.addArrangedSubview(makeCard(dialog: dialog))

        return rowStack
    }

    func makeCard(dialog: MDSDialog) -> UIView {
        let card = UIView()
        card.backgroundColor = .clear

        dialog.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(dialog)

        NSLayoutConstraint.activate([
            dialog.topAnchor.constraint(equalTo: card.topAnchor),
            dialog.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            dialog.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            dialog.trailingAnchor.constraint(equalTo: card.trailingAnchor),
        ])

        return card
    }
}
