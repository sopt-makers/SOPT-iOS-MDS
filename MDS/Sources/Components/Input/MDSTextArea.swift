//
//  MDSTextArea.swift
//  MDS
//

import UIKit

public final class MDSTextArea: UIView {

    // MARK: - Nested Types

    public enum Variant {
        case `default`
        case bold
    }

    /// 외부에서 설정 가능한 상태. .active / .filled는 포커스·텍스트 유무로 자동 결정됩니다.
    /// error는 Figma상 별도 state가 아니라 default/active/filled 어디에나 겹칠 수 있는 독립된 플래그라
    /// state가 아닌 errorMessage의 유무로 표현한다 (disabled일 때는 error보다 우선한다).
    public enum State {
        case `default`
        case disabled
    }

    fileprivate enum ResolvedState {
        case `default`
        case active
        case filled
        case disabled

        func backgroundColor(for variant: MDSTextArea.Variant) -> UIColor {
            switch variant {
            case .default: return SemanticColor.Bg.Layer.default
            case .bold: return SemanticColor.Bg.Neutral.ghost
            }
        }

        var hasBorder: Bool { self == .active }

        var borderColor: CGColor? {
            self == .active ? SemanticColor.Stroke.Neutral.Default.focused.cgColor : nil
        }

        func placeholderColor(for variant: MDSTextArea.Variant) -> UIColor {
            guard self == .disabled else { return SemanticColor.Fg.Neutral.ghost }
            switch variant {
            case .default: return SemanticColor.Fg.Neutral.Ghost.disabled
            case .bold: return SemanticColor.Fg.Neutral.Default.disabled
            }
        }

        var supportingTextColor: UIColor {
            self == .disabled ? SemanticColor.Fg.Neutral.Ghost.disabled : SemanticColor.Fg.Neutral.ghost
        }

        func textColor(for variant: MDSTextArea.Variant) -> UIColor {
            switch self {
            case .default: return SemanticColor.Fg.Neutral.ghost
            case .active, .filled: return SemanticColor.Fg.Neutral.bold
            case .disabled: return SemanticColor.Fg.Neutral.Ghost.disabled
            }
        }
    }

    // MARK: - Public Properties

    public var label: String? {
        didSet {
            titleLabel.text = label
            titleLabel.setTypography(Typography.title5)
            labelRowView.isHidden = label == nil
        }
    }
    public var isRequired: Bool = false {
        didSet { requiredLabel.isHidden = !isRequired }
    }
    public var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
            descriptionLabel.setTypography(Typography.body2)
            descriptionContainerView.isHidden = descriptionText == nil
            updateLabelDescriptionSpacing()
        }
    }

    public var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.setTypography(Typography.body1)
        }
    }

    public var helperText: String? {
        didSet { updateHelperArea() }
    }

    public var errorMessage: String? {
        didSet {
            updateFieldStyle()
            updateHelperArea()
        }
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
        stack.spacing = BaseSpacing.Base.s10
        stack.alignment = .fill
        return stack
    }()

    private let labelRowView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = BaseSpacing.Base.s4
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: BaseSpacing.Base.s2, bottom: 0, trailing: BaseSpacing.Base.s2)
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.title5)
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

    private let descriptionContainerView = UIView()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTypography(Typography.body2)
        label.textColor = SemanticColor.Fg.Neutral.default
        label.numberOfLines = 0
        return label
    }()

    private let inputGroupView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = BaseSpacing.Base.s6
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
        button.tintColor = SemanticColor.Fg.Neutral.default
        return button
    }()

    private let bottomRowView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = BaseSpacing.Base.s20
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: BaseSpacing.Base.s2, bottom: 0, trailing: BaseSpacing.Base.s2)
        return stack
    }()

    private let helperLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.body3)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let errorRowView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = BaseSpacing.Base.s4
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
        label.setTypography(Typography.body3)
        label.textColor = SemanticColor.Fg.Danger.default
        label.numberOfLines = 0
        return label
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.setTypography(Typography.body3)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    /// helperLabel/errorRowView가 둘 다 숨겨져도 counterLabel을 우측에 고정하기 위한 spacer.
    /// 항상 표시 상태를 유지하며, 다른 두 뷰보다 낮은 hugging priority로 남는 공간을 우선 흡수한다.
    private let counterSpacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        return view
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
        bottomRowView.addArrangedSubview(counterSpacerView)
        bottomRowView.addArrangedSubview(counterLabel)

        inputContainer.addSubview(textView)
        inputContainer.addSubview(placeholderLabel)

        inputGroupView.addArrangedSubview(inputContainer)
        inputGroupView.addArrangedSubview(bottomRowView)

        descriptionContainerView.addSubview(descriptionLabel)

        outerStackView.addArrangedSubview(labelRowView)
        outerStackView.addArrangedSubview(descriptionContainerView)
        outerStackView.addArrangedSubview(inputGroupView)
        outerStackView.setCustomSpacing(10, after: descriptionContainerView)

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

            textView.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: BaseSpacing.Base.s10),
            textView.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: BaseSpacing.Base.s16),
            textView.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -BaseSpacing.Base.s10),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),

            errorIconView.widthAnchor.constraint(equalToConstant: 14),
            errorIconView.heightAnchor.constraint(equalToConstant: 14),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: BaseSpacing.Base.s2),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -BaseSpacing.Base.s2),
        ])

        if hasSendButton {
            inputContainer.addSubview(sendButton)
            NSLayoutConstraint.activate([
                textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -BaseSpacing.Base.s14),
                sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -BaseSpacing.Base.s16),
                sendButton.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -13),
                sendButton.widthAnchor.constraint(equalToConstant: 20),
                sendButton.heightAnchor.constraint(equalToConstant: 20),
            ])
        } else {
            NSLayoutConstraint.activate([
                textView.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -BaseSpacing.Base.s16),
            ])
        }
    }

    // init 시 한 번 호출. stored properties 값을 기반으로 초기 뷰 상태를 세팅한다.
    private func initialAppearance() {
        labelRowView.isHidden = label == nil
        titleLabel.text = label
        titleLabel.setTypography(Typography.title5)
        requiredLabel.isHidden = !isRequired

        descriptionContainerView.isHidden = descriptionText == nil
        descriptionLabel.text = descriptionText
        descriptionLabel.setTypography(Typography.body2)
        updateLabelDescriptionSpacing()

        placeholderLabel.text = placeholder

        counterLabel.isHidden = maxLength == nil

        updateFieldStyle()
        updateHelperArea()
        updateCounterLabel()
    }

    // description이 없을 때는 setCustomSpacing(after: descriptionLabel)이 적용되지 않아
    // label-input 간격이 기본값(outerStackView.spacing)으로 떨어지므로, label 뒤쪽 spacing을 직접 전환한다.
    private func updateLabelDescriptionSpacing() {
        outerStackView.setCustomSpacing(descriptionContainerView.isHidden ? BaseSpacing.Base.s10 : BaseSpacing.Base.s2, after: labelRowView)
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
        if textView.isFirstResponder { return .active }
        if !textView.text.isEmpty { return .filled }
        return .default
    }

    // error는 default/active/filled 어디에나 겹칠 수 있는 독립 플래그. disabled에는 밀린다.
    private func isShowingError(for state: ResolvedState) -> Bool {
        state != .disabled && errorMessage != nil
    }

    // MARK: - Update

    private func updateFieldStyle() {
        let state = resolvedState()
        let showsError = isShowingError(for: state)
        inputContainer.backgroundColor = state.backgroundColor(for: variant)
        inputContainer.layer.borderWidth = (showsError || state.hasBorder) ? 1 : 0
        inputContainer.layer.borderColor = showsError
            ? SemanticColor.Stroke.Danger.default.cgColor
            : state.borderColor
        textView.backgroundColor = state.backgroundColor(for: variant)
        textView.textColor = state.textColor(for: variant)
        placeholderLabel.textColor = state.placeholderColor(for: variant)
        placeholderLabel.setTypography(Typography.body1)
        sendButton.tintColor = state == .disabled ? SemanticColor.Fg.Neutral.Default.disabled : SemanticColor.Fg.Neutral.default
    }

    private func updateHelperArea() {
        let state = resolvedState()
        if isShowingError(for: state), let message = errorMessage {
            helperLabel.isHidden = true
            errorRowView.isHidden = false
            errorMessageLabel.text = message
            errorMessageLabel.setTypography(Typography.body3)
        } else if let helper = helperText {
            helperLabel.isHidden = false
            helperLabel.text = helper
            helperLabel.textColor = state.supportingTextColor
            helperLabel.setTypography(Typography.body3)
            errorRowView.isHidden = true
        } else {
            helperLabel.isHidden = true
            errorRowView.isHidden = true
        }
        counterLabel.textColor = state.supportingTextColor
        counterLabel.setTypography(Typography.body3)
        updateBottomRow()
    }

    private func updateCounterLabel() {
        guard let maxLength else { return }
        counterLabel.text = "\(textView.text.count)/\(maxLength)"
        counterLabel.textColor = resolvedState().supportingTextColor
        counterLabel.setTypography(Typography.body3)
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
        counterLabel.setTypography(Typography.body3)
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
