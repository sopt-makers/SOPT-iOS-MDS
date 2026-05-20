//
//  CalloutViewController.swift
//  MDS
//
//  Created by 최주리 on 5/20/26.
//

import UIKit
import MDS

final class CalloutViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Callout"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupCallouts()
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

    private func setupCallouts() {
        MDSCallout.Style.allCases.forEach { style in
            contentStack.addArrangedSubview(makeStyleSection(style: style))
        }
    }

    private func makeStyleSection(style: MDSCallout.Style) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = style.rawValue
        sectionTitle.font = .systemFont(ofSize: 20, weight: .bold)
        sectionTitle.textColor = .label

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 10
        sectionStack.addArrangedSubview(sectionTitle)

        let cases: [(title: String, icon: MDSIcon?, buttonTitle: String?)] = [
            ("Text only", nil, nil),
            ("Icon", MDSIcon.alertCircleOutlined, nil),
            ("Button", nil, "text button"),
            ("Icon + Button", MDSIcon.alertCircleOutlined, "text button"),
        ]

        cases.forEach { item in
            sectionStack.addArrangedSubview(
                makeCalloutRow(
                    title: item.title,
                    style: style,
                    text: "Text",
                    icon: item.icon,
                    buttonTitle: item.buttonTitle
                )
            )
        }

        return sectionStack
    }

    private func makeCalloutRow(
        title: String,
        style: MDSCallout.Style,
        text: String,
        icon: MDSIcon?,
        buttonTitle: String?
    ) -> UIView {
        let rowTitle = UILabel()
        rowTitle.text = title
        rowTitle.font = .systemFont(ofSize: 12, weight: .semibold)
        rowTitle.textColor = .secondaryLabel

        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        let callout = MDSCallout(
            style: style,
            text: text,
            icon: icon,
            buttonTitle: buttonTitle
        )
        callout.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(callout)

        NSLayoutConstraint.activate([
            callout.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            callout.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            callout.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            callout.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
        ])

        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 6
        rowStack.addArrangedSubview(rowTitle)
        rowStack.addArrangedSubview(card)
        return rowStack
    }
}
