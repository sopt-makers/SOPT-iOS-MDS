//
//  MDSTextArea.swift
//  MDS
//

import UIKit

public final class MDSTextArea: UIView {

    // MARK: - Nested Types

    public enum Variant {
        case `default`
        case ghost
    }

    /// 외부에서 설정 가능한 상태. .active / .filled는 포커스·텍스트 유무로 자동 결정됩니다.
    public enum State {
        case `default`
        case error
        case disabled
    }

    fileprivate enum ResolvedState {
        case `default`
        case active
        case filled
        case error
        case disabled
    }

    // MARK: - Public Properties

    public var label: String? {
        didSet {
            titleLabel.text = label
            titleLabel.setTypography(Typography.title4)
            labelRowView.isHidden = label == nil
        }
    }
    public var isRequired: Bool = false {
        didSet { requiredLabel.isHidden = !isRequired }
    }
    public var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
            descriptionLabel.setTypography(Typography.label3)
            descriptionLabel.isHidden = descriptionText == nil
        }
    }
    public var placeholder: String?
    public var helperText: String? {
        didSet { updateHelperArea() }
    }
    public var errorMessage: String? {
        didSet { if state == .error { updateHelperArea() } }
    }
    public var maxLength: Int? {
        didSet {
            counterLabel.isHidden = maxLength == nil
            updateCounterLabel()
            updateBottomRow()
        }
    }
    public var onSendTapped: (() -> Void)?

    public var sendButtonIcon: MDSIcon = .sendOutlined {
        didSet { sendButton.setImage(sendButtonIcon.image.withRenderingMode(.alwaysTemplate), for: .normal) }
    }

    public var text: String? {
        get { textView.text.isEmpty ? nil : textView.text }
        set {
            textView.text = newValue ?? ""
            textView.setTypography(Typography.body1)
            placeholderLabel.isHidden = !textView.text.isEmpty
            updateFieldStyle()
            updateCounterLabel()
            updateTextViewHeight()
        }
    }

    public var state: State = .default {
        didSet { applyState() }
    }

    // MARK: - Private Properties

    /// 입력 영역 기본(최소) 높이.
    private static let minHeight: CGFloat = 48

    /// 입력 영역 최대 높이. 초과하면 내부 스크롤로 전환된다.
    private static let maxHeight: CGFloat = 150

    private let variant: Variant
    private let hasSendButton: Bool
    private var textViewHeightConstraint: NSLayoutConstraint?

    // MARK: - Subviews

    private let outerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()

    private let labelRowView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.title4)
        label.textColor = SemanticColor.Fg.Neutral.bold
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let requiredLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = SemanticColor.Fg.Brand.default
        label.setTypography(Typography.title4)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.label3)
        label.textColor = SemanticColor.Fg.Neutral.subtle
        label.numberOfLines = 0
        return label
    }()

    private let inputGroupView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .fill
        return stack
    }()

    private let inputContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = BaseRadius.Base.r10
        view.layer.masksToBounds = true
        return view
    }()

    private let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.showsHorizontalScrollIndicator = false
        view.textColor = SemanticColor.Fg.Neutral.bold
        view.setTypography(Typography.body1)
        return view
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = SemanticColor.Fg.Neutral.ghost
        label.setTypography(Typography.body1)
        label.numberOfLines = 0
        return label
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = SemanticColor.Fg.Neutral.bold
        return button
    }()

    private let bottomRowView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()

    private let helperLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.body2)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let errorRowView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stack
    }()

    private let errorIconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = MDSIcon.infoCircleOutlined.image.withRenderingMode(.alwaysTemplate)
        view.tintColor = SemanticColor.Fg.Danger.default
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.body2)
        label.textColor = SemanticColor.Fg.Danger.default
        label.numberOfLines = 0
        return label
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.body2)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    // MARK: - Init

    public init(
        variant: Variant = .default,
        hasSendButton: Bool = false,
        placeholder: String? = nil,
        label: String? = nil,
        isRequired: Bool = false,
        descriptionText: String? = nil,
        helperText: String? = nil,
        errorMessage: String? = nil,
        maxLength: Int? = nil
    ) {
        self.variant = variant
        self.hasSendButton = hasSendButton
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.label = label
        self.isRequired = isRequired
        self.descriptionText = descriptionText
        self.helperText = helperText
        self.errorMessage = errorMessage
        self.maxLength = maxLength
        setupUI()
        setupLayout()
        initialAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupUI() {
        textView.delegate = self
        sendButton.setImage(sendButtonIcon.image.withRenderingMode(.alwaysTemplate), for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        labelRowView.addArrangedSubview(titleLabel)
        labelRowView.addArrangedSubview(requiredLabel)

        errorRowView.addArrangedSubview(errorIconView)
        errorRowView.addArrangedSubview(errorMessageLabel)

        bottomRowView.addArrangedSubview(helperLabel)
        bottomRowView.addArrangedSubview(errorRowView)
        bottomRowView.addArrangedSubview(counterLabel)

        inputContainer.addSubview(textView)
        inputContainer.addSubview(placeholderLabel)

        inputGroupView.addArrangedSubview(inputContainer)
        inputGroupView.addArrangedSubview(bottomRowView)

        outerStackView.addArrangedSubview(labelRowView)
        outerStackView.addArrangedSubview(descriptionLabel)
        outerStackView.addArrangedSubview(inputGroupView)

        addSubview(outerStackView)
    }

    private func setupLayout() {
        // 측정한 텍스트 높이를 따라가는 constraint. 컨테이너 min/max에 걸리면 우선순위가 낮아 깨지고,
        // max에서는 contentSize가 프레임보다 커지면서 내부 스크롤로 전환된다.
        let heightConstraint = textView.heightAnchor.constraint(equalToConstant: Self.minHeight - 20)
        heightConstraint.priority = .defaultHigh
        textViewHeightConstraint = heightConstraint

        NSLayoutConstraint.activate([
            heightConstraint,
            inputContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: Self.minHeight),
            inputContainer.heightAnchor.constraint(lessThanOrEqualToConstant: Self.maxHeight),

            outerStackView.topAnchor.constraint(equalTo: topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            textView.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -10),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),

            errorIconView.widthAnchor.constraint(equalToConstant: 14),
            errorIconView.heightAnchor.constraint(equalToConstant: 14),
        ])

        if hasSendButton {
            inputContainer.addSubview(sendButton)
            NSLayoutConstraint.activate([
                textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -14),
                sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -14),
                sendButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
                sendButton.widthAnchor.constraint(equalToConstant: 20),
                sendButton.heightAnchor.constraint(equalToConstant: 20),
            ])
        } else {
            NSLayoutConstraint.activate([
                textView.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -14),
            ])
        }
    }

    // init 시 한 번 호출. stored properties 값을 기반으로 초기 뷰 상태를 세팅한다.
    private func initialAppearance() {
        labelRowView.isHidden = label == nil
        titleLabel.text = label
        titleLabel.setTypography(Typography.title4)
        requiredLabel.isHidden = !isRequired

        descriptionLabel.isHidden = descriptionText == nil
        descriptionLabel.text = descriptionText
        descriptionLabel.setTypography(Typography.label3)

        placeholderLabel.text = placeholder
        placeholderLabel.setTypography(Typography.body1)

        counterLabel.isHidden = maxLength == nil

        updateFieldStyle()
        updateHelperArea()
        updateCounterLabel()
    }

    // MARK: - State

    private func applyState() {
        textView.isEditable = state != .disabled
        textView.isSelectable = state != .disabled
        updateFieldStyle()
        updateHelperArea()
        updateCounterLabel()
    }

    // 외부 state, 포커스, 텍스트 유무를 조합해 렌더링 상태를 계산한다. UI를 직접 변경하지 않는다.
    private func resolvedState() -> ResolvedState {
        if state == .disabled { return .disabled }
        if state == .error { return .error }
        if textView.isFirstResponder { return .active }
        if !textView.text.isEmpty { return .filled }
        return .default
    }

    // MARK: - Update

    private func updateFieldStyle() {
        let state = resolvedState()
        inputContainer.backgroundColor = state.backgroundColor(for: variant)
        inputContainer.layer.borderWidth = state.hasBorder ? 1 : 0
        inputContainer.layer.borderColor = state.borderColor
        textView.textColor = state.textColor
        placeholderLabel.textColor = state.ghostColor
        placeholderLabel.setTypography(Typography.body1)
    }

    private func updateHelperArea() {
        let state = resolvedState()
        if state == .error, let message = errorMessage {
            helperLabel.isHidden = true
            errorRowView.isHidden = false
            errorMessageLabel.text = message
            errorMessageLabel.setTypography(Typography.body2)
        } else if let helper = helperText {
            helperLabel.isHidden = false
            helperLabel.text = helper
            helperLabel.textColor = state.ghostColor
            helperLabel.setTypography(Typography.body2)
            errorRowView.isHidden = true
        } else {
            helperLabel.isHidden = true
            errorRowView.isHidden = true
        }
        counterLabel.textColor = state.ghostColor
        counterLabel.setTypography(Typography.body2)
        updateBottomRow()
    }

    private func updateCounterLabel() {
        guard let maxLength else { return }
        counterLabel.text = "\(textView.text.count)/\(maxLength)"
        counterLabel.textColor = resolvedState().ghostColor
        counterLabel.setTypography(Typography.body2)
    }

    private func updateBottomRow() {
        bottomRowView.isHidden = helperLabel.isHidden && errorRowView.isHidden && counterLabel.isHidden
    }

    // 현재 폭 기준으로 텍스트 높이를 측정해 height constraint에 반영한다.
    private func updateTextViewHeight() {
        guard textView.bounds.width > 0 else { return }
        let fittingHeight = ceil(textView.sizeThatFits(
            CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        ).height)
        guard textViewHeightConstraint?.constant != fittingHeight else { return }
        textViewHeightConstraint?.constant = fittingHeight
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateTextViewHeight()
    }

    // MARK: - Actions

    @objc private func sendButtonTapped() {
        onSendTapped?()
    }
}

// MARK: - ResolvedState Appearance

private extension MDSTextArea.ResolvedState {

    func backgroundColor(for variant: MDSTextArea.Variant) -> UIColor {
        switch variant {
        case .default: return SemanticColor.Bg.Layer.default
        case .ghost: return SemanticColor.Bg.Neutral.ghost
        }
    }

    var hasBorder: Bool { self == .active || self == .error }

    var borderColor: CGColor? {
        switch self {
        case .active: return SemanticColor.Stroke.Neutral.Default.focused.cgColor
        case .error: return SemanticColor.Stroke.Danger.default.cgColor
        default: return nil
        }
    }

    var textColor: UIColor {
        self == .disabled ? SemanticColor.Fg.Neutral.Default.disabled : SemanticColor.Fg.Neutral.bold
    }

    var ghostColor: UIColor {
        self == .disabled ? SemanticColor.Fg.Neutral.Ghost.disabled : SemanticColor.Fg.Neutral.ghost
    }
}

// MARK: - UITextViewDelegate

extension MDSTextArea: UITextViewDelegate {

    public func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        guard let maxLength else { return true }
        let currentText = textView.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        guard newText.count <= maxLength else { return false }
        counterLabel.text = "\(newText.count)/\(maxLength)"
        counterLabel.setTypography(Typography.body2)
        return true
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        updateFieldStyle()
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        updateFieldStyle()
        updateCounterLabel()
    }

    public func textViewDidChange(_ textView: UITextView) {
        // 텍스트를 전부 지우면 typingAttributes가 초기화되므로 다시 지정한다.
        // 입력 중에는 호출하지 않는다. attributedText 재설정이 한글 조합을 끊기 때문.
        if textView.text.isEmpty {
            textView.setTypography(Typography.body1)
        }
        placeholderLabel.isHidden = !textView.text.isEmpty
        updateTextViewHeight()
    }
}
