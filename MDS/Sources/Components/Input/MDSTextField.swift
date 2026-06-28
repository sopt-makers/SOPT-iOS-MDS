//
//  MDSTextField.swift
//  MDS
//

import UIKit

public final class MDSTextField: UIView {

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

    private enum ResolvedState {
        case `default`
        case active
        case filled
        case error
        case disabled
    }

    private enum Layout {
        static let textFieldHeight: CGFloat = 48
        static let horizontalPadding: CGFloat = 16
    }

    // MARK: - Public Properties

    public var label: String?
    public var isRequired: Bool = false
    public var descriptionText: String?
    public var placeholder: String?
    public var helperText: String?
    public var errorMessage: String?
    public var maxLength: Int?

    public var text: String? {
        get { textField.text }
        set {
            textField.text = newValue
            updateFieldStyle()
            updateCounterLabelContent()
        }
    }

    public var state: State = .default {
        didSet { applyState() }
    }

    // MARK: - Private Properties

    private let variant: Variant

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
        label.numberOfLines = 1
        label.font = Typography.title4.font
        label.textColor = SemanticColor.Fg.Neutral.bold
        return label
    }()

    private let requiredLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = Typography.title4.font
        label.textColor = SemanticColor.Fg.Brand.default
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Typography.label3.font
        label.textColor = SemanticColor.Fg.Neutral.subtle
        return label
    }()

    private let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .none
        field.font = Typography.body1.font
        field.layer.cornerRadius = BaseRadius.Base.r10
        field.layer.masksToBounds = true
        return field
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
        label.numberOfLines = 0
        label.font = Typography.body2.font
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = Typography.body2.font
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    // MARK: - Init

    public init(variant: Variant = .default, placeholder: String? = nil) {
        self.variant = variant
        super.init(frame: .zero)
        self.placeholder = placeholder
        setupUI()
        setupLayout()
        initialAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupUI() {
        textField.delegate = self

        let paddingSize = CGSize(width: Layout.horizontalPadding, height: Layout.textFieldHeight)
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: paddingSize))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(origin: .zero, size: paddingSize))
        textField.rightViewMode = .always

        labelRowView.addArrangedSubview(titleLabel)
        labelRowView.addArrangedSubview(requiredLabel)

        bottomRowView.addArrangedSubview(helperLabel)
        bottomRowView.addArrangedSubview(counterLabel)

        outerStackView.addArrangedSubview(labelRowView)
        outerStackView.addArrangedSubview(descriptionLabel)
        outerStackView.addArrangedSubview(textField)
        outerStackView.addArrangedSubview(bottomRowView)

        addSubview(outerStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: Layout.textFieldHeight),
        ])
    }

    // init 시 한 번 호출. stored properties 값을 기반으로 초기 뷰 상태를 세팅한다.
    private func initialAppearance() {
        if let placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .foregroundColor: SemanticColor.Fg.Neutral.ghost,
                    .font: Typography.body1.font
                ]
            )
        }

        labelRowView.isHidden = label == nil
        titleLabel.text = label
        requiredLabel.isHidden = !isRequired

        descriptionLabel.isHidden = descriptionText == nil
        descriptionLabel.text = descriptionText

        counterLabel.isHidden = maxLength == nil

        updateFieldStyle()
        updateHelperArea()
        updateCounterLabelContent()
    }

    // MARK: - State

    private func applyState() {
        textField.isEnabled = state != .disabled
        updateFieldStyle()
        updateHelperArea()
    }

    // 외부 state, 포커스, 텍스트 유무를 조합해 렌더링 상태를 계산한다. UI를 직접 변경하지 않는다.
    private func resolvedState() -> ResolvedState {
        if state == .disabled { return .disabled }
        if state == .error { return .error }
        if textField.isFirstResponder { return .active }
        if !(textField.text?.isEmpty ?? true) { return .filled }
        return .default
    }

    // MARK: - Update

    private func updateFieldStyle() {
        let effectiveState = resolvedState()
        textField.backgroundColor = effectiveState.backgroundColor(for: variant)
        textField.layer.borderWidth = effectiveState.hasBorder ? 1 : 0
        textField.layer.borderColor = effectiveState.borderColor
        textField.textColor = effectiveState.foregroundColor
    }

    private func updateHelperArea() {
        let effectiveState = resolvedState()
        if effectiveState == .error, let message = errorMessage {
            helperLabel.isHidden = false
            helperLabel.text = message
            helperLabel.textColor = SemanticColor.Fg.Danger.default
        } else if let helper = helperText {
            helperLabel.isHidden = false
            helperLabel.text = helper
            helperLabel.textColor = effectiveState.ghostColor
        } else {
            helperLabel.isHidden = true
        }
        updateBottomRow()
    }

    private func updateCounterLabelContent() {
        guard let maxLength else { return }
        counterLabel.text = "\(textField.text?.count ?? 0)/\(maxLength)"
        counterLabel.textColor = resolvedState().ghostColor
    }

    private func updateBottomRow() {
        bottomRowView.isHidden = helperLabel.isHidden && counterLabel.isHidden
    }
}

// MARK: - ResolvedState Appearance

private extension MDSTextField.ResolvedState {

    func backgroundColor(for variant: MDSTextField.Variant) -> UIColor {
        if variant == .ghost { return .clear }
        return self == .disabled
            ? SemanticColor.Bg.Neutral.Default.disabled
            : SemanticColor.Bg.Neutral.ghost
    }

    var hasBorder: Bool {
        self == .active || self == .error
    }

    var borderColor: CGColor? {
        switch self {
        case .active: return SemanticColor.Stroke.Neutral.Default.focused.cgColor
        case .error: return SemanticColor.Stroke.Danger.default.cgColor
        default: return nil
        }
    }

    var ghostColor: UIColor {
        self == .disabled ? SemanticColor.Fg.Neutral.Ghost.disabled : SemanticColor.Fg.Neutral.ghost
    }

    var foregroundColor: UIColor {
        self == .disabled
            ? SemanticColor.Fg.Neutral.Default.disabled
            : SemanticColor.Fg.Neutral.bold
    }
}

// MARK: - UITextFieldDelegate

extension MDSTextField: UITextFieldDelegate {

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let maxLength else { return true }
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        guard newText.count <= maxLength else { return false }
        counterLabel.text = "\(newText.count)/\(maxLength)"
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateFieldStyle()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateFieldStyle()
        updateCounterLabelContent()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
