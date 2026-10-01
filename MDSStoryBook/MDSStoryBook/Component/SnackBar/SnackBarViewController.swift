//
//  SnackBarViewController.swift
//  MDSStoryBook
//
//  Created by 최주리 on 10/1/26.
//

import UIKit
import MDS

final class SnackBarViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let cases: [(title: String, style: MDSSnackBar.Style, text: String, buttonTitle: String?)] = [
        ("Default", .default, "저는 토스트예요.", nil),
        ("Success", .success, "프로젝트가 등록되었어요.", nil),
        ("Alert", .alert, "이메일을 다시 입력해주세요.", nil),
        ("Error", .error, "업로드에 실패했어요.", nil),
        ("Action Button", .default, "저는 토스트예요.", "보러가기"),
        ("Icon + Action Button", .success, "프로젝트가 등록되었어요.", "보러가기"),
        ("Two Lines", .success, "두 줄이 필요하면 두 줄 쓰세요. (세 줄은 안돼)\n근데 중요한 건 간결하게 쓰는 것!", nil),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SnackBar"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupContent()
    }

    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func setupContent() {
        cases.enumerated().forEach { index, item in
            let button = MDSActionButton(variant: .secondary, size: .large, title: item.title)
            button.tag = index
            button.addTarget(self, action: #selector(showTapped(_:)), for: .touchUpInside)
            contentStack.addArrangedSubview(button)
        }
    }

    @objc private func showTapped(_ sender: UIControl) {
        let item = cases[sender.tag]
        MDSSnackBar(
            style: item.style,
            text: item.text,
            buttonTitle: item.buttonTitle,
            onButtonTap: { print("snackbar button tapped") }
        ).show(in: view)
    }
}
