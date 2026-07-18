//
//  TextAreaViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class TextAreaViewController: UIViewController {

    // MARK: - Options State

    private var fieldVariant: MDSTextArea.Variant = .default
    private var fieldState: MDSTextArea.State = .default
    private var showLabel = false
    private var showRequired = false
    private var showDescription = false
    private var showHelperText = false
    private var showTextCounter = false
    private var showSendButton = false

    // MARK: - Control References

    private weak var requiredSwitch: UISwitch?
    private var previewTextArea: MDSTextArea!

    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.keyboardDismissMode = .interactive
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 24
        view.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let previewCard: UIView = {
        let view = UIView()
        view.backgroundColor = SemanticColor.Bg.Dim.default
        view.layer.cornerRadius = 12
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Text Area"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        addPreviewSection()
        addControlsSection()
        setupTextArea()
        setupKeyboardHandling()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Layout

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

    // MARK: - Preview

    private func addPreviewSection() {
        contentStack.addArrangedSubview(makeSectionTitle("Preview"))
        contentStack.addArrangedSubview(previewCard)
    }

    private func setupTextArea() {
        previewTextArea?.removeFromSuperview()

        let ta = MDSTextArea(
            variant: fieldVariant,
            hasSendButton: showSendButton,
            placeholder: "Placeholder text",
            errorMessage: "Error message"
        )
        ta.translatesAutoresizingMaskIntoConstraints = false
        previewCard.addSubview(ta)

        NSLayoutConstraint.activate([
            ta.topAnchor.constraint(equalTo: previewCard.topAnchor, constant: 16),
            ta.leadingAnchor.constraint(equalTo: previewCard.leadingAnchor, constant: 16),
            ta.trailingAnchor.constraint(equalTo: previewCard.trailingAnchor, constant: -16),
            ta.bottomAnchor.constraint(equalTo: previewCard.bottomAnchor, constant: -16),
        ])

        previewTextArea = ta
        applyCurrentOptions()
    }

    private func applyCurrentOptions() {
        previewTextArea.label = showLabel ? "Label" : nil
        previewTextArea.isRequired = showLabel && showRequired
        previewTextArea.descriptionText = showDescription ? "Input description" : nil
        previewTextArea.helperText = showHelperText ? "Helper text" : nil
        previewTextArea.maxLength = showTextCounter ? 200 : nil
        previewTextArea.state = fieldState
    }

    // MARK: - Controls

    private func addControlsSection() {
        contentStack.addArrangedSubview(makeSectionTitle("Controls"))
        contentStack.addArrangedSubview(makeControlsCard())
    }

    private func makeControlsCard() -> UIView {
        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
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

        let variantControl = UISegmentedControl(items: ["Default", "Bold"])
        variantControl.selectedSegmentIndex = 0
        variantControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        variantControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        variantControl.addTarget(self, action: #selector(variantChanged(_:)), for: .valueChanged)
        stack.addArrangedSubview(makeControlRow(title: "Variant", control: variantControl))

        let stateControl = UISegmentedControl(items: ["Default", "Error", "Disabled"])
        stateControl.selectedSegmentIndex = 0
        stateControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        stateControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        stateControl.addTarget(self, action: #selector(stateChanged(_:)), for: .valueChanged)
        stack.addArrangedSubview(makeControlRow(title: "State", control: stateControl))

        stack.addArrangedSubview(makeSeparator())

        stack.addArrangedSubview(makeSwitchRow(title: "Label", action: #selector(labelToggled(_:))).view)

        let requiredRow = makeSwitchRow(title: "Required (*)", action: #selector(requiredToggled(_:)))
        requiredRow.toggle.isEnabled = false
        requiredSwitch = requiredRow.toggle
        stack.addArrangedSubview(requiredRow.view)

        stack.addArrangedSubview(makeSwitchRow(title: "Description", action: #selector(descriptionToggled(_:))).view)
        stack.addArrangedSubview(makeSwitchRow(title: "Helper Text", action: #selector(helperTextToggled(_:))).view)
        stack.addArrangedSubview(makeSwitchRow(title: "Text Counter", action: #selector(textCounterToggled(_:))).view)
        stack.addArrangedSubview(makeSwitchRow(title: "Send Button", action: #selector(sendButtonToggled(_:))).view)

        return card
    }

    // MARK: - Row Builders

    private func makeSectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }

    private func makeControlRow(title: String, control: UIView) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor.white.withAlphaComponent(0.6)

        let stack = UIStackView(arrangedSubviews: [label, control])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }

    private func makeSwitchRow(title: String, action: Selector) -> (view: UIStackView, toggle: UISwitch) {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white

        let toggle = UISwitch()
        toggle.addTarget(self, action: action, for: .valueChanged)

        let stack = UIStackView(arrangedSubviews: [label, toggle])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return (stack, toggle)
    }

    private func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }

    // MARK: - Keyboard

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = frame.height - view.safeAreaInsets.bottom
    }

    @objc private func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
    }

    // MARK: - Actions

    @objc private func variantChanged(_ sender: UISegmentedControl) {
        fieldVariant = sender.selectedSegmentIndex == 0 ? .default : .bold
        setupTextArea()
    }

    @objc private func stateChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: fieldState = .error
        case 2: fieldState = .disabled
        default: fieldState = .default
        }
        previewTextArea.state = fieldState
    }

    @objc private func labelToggled(_ sender: UISwitch) {
        showLabel = sender.isOn
        if !sender.isOn {
            showRequired = false
            requiredSwitch?.setOn(false, animated: true)
        }
        requiredSwitch?.isEnabled = sender.isOn
        previewTextArea.label = showLabel ? "Label" : nil
        previewTextArea.isRequired = showLabel && showRequired
    }

    @objc private func requiredToggled(_ sender: UISwitch) {
        showRequired = sender.isOn
        previewTextArea.isRequired = sender.isOn
    }

    @objc private func descriptionToggled(_ sender: UISwitch) {
        showDescription = sender.isOn
        previewTextArea.descriptionText = sender.isOn ? "Input description" : nil
    }

    @objc private func helperTextToggled(_ sender: UISwitch) {
        showHelperText = sender.isOn
        previewTextArea.helperText = sender.isOn ? "Helper text" : nil
    }

    @objc private func textCounterToggled(_ sender: UISwitch) {
        showTextCounter = sender.isOn
        previewTextArea.maxLength = sender.isOn ? 200 : nil
    }

    @objc private func sendButtonToggled(_ sender: UISwitch) {
        showSendButton = sender.isOn
        setupTextArea()
    }
}
