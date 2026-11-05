//
//  NavigationBarViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class NavigationBarViewController: UIViewController {

    // MARK: - State (Figma Component properties)

    private var rightIconStates = [true, true, true]
    private var showsRightButton = true
    private var isActionButton = false

    // MARK: - Subviews

    private let navigationBar = MDSNavigationBar(
        leftIcon: true,
        title: .title("Title"),
        rightIcons: [.heartOutlined, .heartOutlined, .heartOutlined],
        rightButton: .textButton("text button")
    )

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NavigationBar"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupContent()
    }

    private func setupLayout() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
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
        navigationBar.onLeftIconTap = { print("left icon tap") }
        navigationBar.onRightIconTap = { print("right icon tap: \($0)") }
        navigationBar.onRightButtonTap = { print("right button tap") }

        contentStack.addArrangedSubview(makeControlsCard(rows: [
            makeSwitchRow(title: "LeftIcon", isOn: navigationBar.leftIcon) { [weak self] isOn in
                self?.navigationBar.leftIcon = isOn
            },
            makeSegmentRow(title: "TitleSlot", items: ["Title", "Logo", "Custom"]) { [weak self] index in
                guard let self else { return }
                switch index {
                case 1: navigationBar.title = .logo
                case 2: navigationBar.title = .custom(makeCustomTitleView())
                default: navigationBar.title = .title("Title")
                }
            },
            makeSwitchRow(title: "RightIcon01", isOn: rightIconStates[0]) { [weak self] isOn in
                self?.rightIconStates[0] = isOn
                self?.updateRightIcons()
            },
            makeSwitchRow(title: "RightIcon02", isOn: rightIconStates[1]) { [weak self] isOn in
                self?.rightIconStates[1] = isOn
                self?.updateRightIcons()
            },
            makeSwitchRow(title: "RightIcon03", isOn: rightIconStates[2]) { [weak self] isOn in
                self?.rightIconStates[2] = isOn
                self?.updateRightIcons()
            },
            makeSwitchRow(title: "RightButton", isOn: showsRightButton) { [weak self] isOn in
                self?.showsRightButton = isOn
                self?.updateRightButton()
            },
            makeSegmentRow(title: "Button", items: ["TextButton", "ActionButton"]) { [weak self] index in
                self?.isActionButton = index == 1
                self?.updateRightButton()
            },
        ]))

        let usageButton = MDSActionButton(variant: .secondary, size: .medium, title: "실제 사용 예시 보기")
        usageButton.addAction(UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(NavigationBarUsageHomeViewController(), animated: true)
        }, for: .touchUpInside)
        contentStack.addArrangedSubview(usageButton)
    }

    // MARK: - Update

    /// TitleSlot `.custom` 예시: 타이틀 + 태그
    private func makeCustomTitleView() -> UIView {
        let label = UILabel()
        label.text = "Title"
        label.setTypography(Typography.title4, textColor: SemanticColor.Fg.Neutral.bold)

        let stack = UIStackView(arrangedSubviews: [label, MDSTag(text: "NEW", size: .small)])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        return stack
    }

    private func updateRightIcons() {
        navigationBar.rightIcons = rightIconStates.filter { $0 }.map { _ in .heartOutlined }
    }

    private func updateRightButton() {
        guard showsRightButton else {
            navigationBar.rightButton = nil
            return
        }
        navigationBar.rightButton = isActionButton ? .actionButton("Button") : .textButton("text button")
    }

    // MARK: - Controls

    private func makeControlsCard(rows: [UIView]) -> UIView {
        let stack = UIStackView(arrangedSubviews: rows)
        stack.axis = .vertical
        stack.spacing = 16
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = .secondarySystemGroupedBackground
        stack.layer.cornerRadius = 12
        return stack
    }

    private func makeSwitchRow(title: String, isOn: Bool, onChange: @escaping (Bool) -> Void) -> UIView {
        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.addAction(UIAction { action in
            guard let toggle = action.sender as? UISwitch else { return }
            onChange(toggle.isOn)
        }, for: .valueChanged)
        return makeRow(title: title, control: toggle)
    }

    private func makeSegmentRow(title: String, items: [String], onChange: @escaping (Int) -> Void) -> UIView {
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.addAction(UIAction { action in
            guard let segment = action.sender as? UISegmentedControl else { return }
            onChange(segment.selectedSegmentIndex)
        }, for: .valueChanged)
        return makeRow(title: title, control: segment)
    }

    private func makeRow(title: String, control: UIView) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label

        let stack = UIStackView(arrangedSubviews: [label, control])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }
}
