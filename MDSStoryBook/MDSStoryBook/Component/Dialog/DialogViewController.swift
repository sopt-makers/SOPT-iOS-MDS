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

    private var showDescription = true
    private var showCheckbox = false

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

    private let previewStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 32
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dialog"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        addControlsSection()
        contentStack.addArrangedSubview(previewStack)
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
        previewStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dialogs.removeAll()

        previewStack.addArrangedSubview(
            makeSection(
                title: "Default",
                makeVariant: {
                    .default(
                        primaryButtonTitle: "Button",
                        primaryButtonPrefixImage: nil,
                        primaryButtonSuffixImage: nil,
                        secondaryButtonTitle: "Button",
                        secondaryButtonPrefixImage: nil,
                        secondaryButtonSuffixImage: nil
                    )
                })
        )
        previewStack.addArrangedSubview(
            makeSection(
                title: "Information",
                makeVariant: {
                    .information(
                        primaryButtonTitle: "Button",
                        primaryButtonPrefixImage: nil,
                        primaryButtonSuffixImage: nil
                    )
                })
        )
        previewStack.addArrangedSubview(
            makeSection(
                title: "Danger",
                makeVariant: {
                    .danger(
                        primaryButtonTitle: "Button",
                        primaryButtonPrefixImage: nil,
                        primaryButtonSuffixImage: nil,
                        secondaryButtonTitle: "Button",
                        secondaryButtonPrefixImage: nil,
                        secondaryButtonSuffixImage: nil
                    )
                })
        )
    }
}

// MARK: - Controls

private extension DialogViewController {

    func addControlsSection() {
        let sectionTitle = UILabel()
        sectionTitle.text = "Controls"
        sectionTitle.font = .systemFont(ofSize: 20, weight: .bold)
        sectionTitle.textColor = .label

        let controlsStack = UIStackView()
        controlsStack.axis = .vertical
        controlsStack.spacing = 10
        controlsStack.addArrangedSubview(sectionTitle)
        controlsStack.addArrangedSubview(makeControlsCard())

        contentStack.addArrangedSubview(controlsStack)
    }

    func makeControlsCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 12

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor),
        ])

        let descriptionRow = makeSwitchRow(title: "Description", isOn: showDescription, action: #selector(descriptionToggled(_:)))
        stack.addArrangedSubview(descriptionRow)

        let checkboxRow = makeSwitchRow(title: "Checkbox", isOn: showCheckbox, action: #selector(checkboxToggled(_:)))
        stack.addArrangedSubview(checkboxRow)

        return card
    }

    func makeSwitchRow(title: String, isOn: Bool, action: Selector) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label

        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.addTarget(self, action: action, for: .valueChanged)

        let stack = UIStackView(arrangedSubviews: [label, toggle])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }

    @objc func descriptionToggled(_ sender: UISwitch) {
        showDescription = sender.isOn
        setupContent()
    }

    @objc func checkboxToggled(_ sender: UISwitch) {
        showCheckbox = sender.isOn
        setupContent()
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
        sectionStack.addArrangedSubview(makeCard(variant: makeVariant()))

        return sectionStack
    }

    func makeCard(variant: MDSDialog.Variant) -> UIView {
        let dialog = MDSDialog(
            variant: variant,
            title: "Title Text",
            description: showDescription ? "Description Text\nDescription Text" : nil,
            checkBoxTitle: showCheckbox ? "check box" : nil
        )
        dialog.onPrimaryTap = { print("primary tapped") }
        dialog.onSecondaryTap = { print("secondary tapped") }
        dialogs.append(dialog)

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
