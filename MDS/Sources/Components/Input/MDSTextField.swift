//
//  MDSTextField.swift
//  MDS
//

import UIKit

public final class MDSTextField: UIView {

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

    private enum ResolvedState {
        case `default`
        case active
        case filled
        case disabled

        func backgroundColor(for variant: MDSTextField.Variant) -> UIColor {
            switch variant {
            case .default: return SemanticColor.Bg.Layer.default
            case .bold: return SemanticColor.Bg.Neutral.ghost
            }
        }

        var hasBorder: Bool { self == .active }

        var borderColor: CGColor? {
            self == .active ? SemanticColor.Stroke.Neutral.Default.focused.cgColor : nil
        }

        var ghostColor: UIColor {
            self == .disabled ? SemanticColor.Fg.Neutral.Ghost.disabled : SemanticColor.Fg.Neutral.ghost
        }

        func placeholderColor(for variant: MDSTextField.Variant) -> UIColor {
            guard self == .disabled else { return SemanticColor.Fg.Neutral.ghost }
            switch variant {
            case .default: return SemanticColor.Fg.Neutral.Ghost.disabled
            case .bold: return SemanticColor.Fg.Neutral.Default.disabled
            }
        }

        var foregroundColor: UIColor {
            self == .disabled
                ? SemanticColor.Fg.Neutral.Default.disabled
                : SemanticColor.Fg.Neutral.bold
        }
    }

    private enum Layout {
        static let textFieldHeight: CGFloat = 46
        static let horizontalPadding: CGFloat = BaseSpacing.Base.s16
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
        didSet { updatePlaceholder() }
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
            updateCounterLabelContent()
            updateBottomRow()
        }
    }

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
        label.numberOfLines = 1
        label.setTypography(Typography.title5, textColor: SemanticColor.Fg.Neutral.bold)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let requiredLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.setTypography(Typography.title4, textColor: SemanticColor.Fg.Brand.default)
        return label
    }()

    private let descriptionContainerView = UIView()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.setTypography(Typography.body2, textColor: SemanticColor.Fg.Neutral.default)
        return label
    }()

    private let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .none
        field.setTypography(Typography.body1)
        field.layer.cornerRadius = BaseRadius.Base.r10
        field.layer.masksToBounds = true
        return field
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
        label.numberOfLines = 0
        label.setTypography(Typography.body3)
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
        label.setTypography(Typography.body3, textColor: SemanticColor.Fg.Danger.default)
        label.numberOfLines = 0
        return label
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
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
        placeholder: String? = nil,
        label: String? = nil,
        isRequired: Bool = false,
        descriptionText: String? = nil,
        helperText: String? = nil,
        errorMessage: String? = nil,
        maxLength: Int? = nil
    ) {
        self.variant = variant
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
        textField.delegate = self

        let paddingSize = CGSize(width: Layout.horizontalPadding, height: Layout.textFieldHeight)
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: paddingSize))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(origin: .zero, size: paddingSize))
        textField.rightViewMode = .always

        labelRowView.addArrangedSubview(titleLabel)
        labelRowView.addArrangedSubview(requiredLabel)

        errorRowView.addArrangedSubview(errorIconView)
        errorRowView.addArrangedSubview(errorMessageLabel)

        bottomRowView.addArrangedSubview(helperLabel)
        bottomRowView.addArrangedSubview(errorRowView)
        bottomRowView.addArrangedSubview(counterSpacerView)
        bottomRowView.addArrangedSubview(counterLabel)

        descriptionContainerView.addSubview(descriptionLabel)

        outerStackView.addArrangedSubview(labelRowView)
        outerStackView.addArrangedSubview(descriptionContainerView)
        outerStackView.addArrangedSubview(textField)
        outerStackView.addArrangedSubview(bottomRowView)
        outerStackView.setCustomSpacing(BaseSpacing.Base.s10, after: descriptionContainerView)
        outerStackView.setCustomSpacing(BaseSpacing.Base.s6, after: textField)

        addSubview(outerStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: Layout.textFieldHeight),

            errorIconView.widthAnchor.constraint(equalToConstant: 14),
            errorIconView.heightAnchor.constraint(equalToConstant: 14),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: BaseSpacing.Base.s2),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -BaseSpacing.Base.s2),
        ])
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

        counterLabel.isHidden = maxLength == nil

        updateFieldStyle()
        updateHelperArea()
        updateCounterLabelContent()
    }

    // description이 없을 때는 setCustomSpacing(after: descriptionLabel)이 적용되지 않아
    // label-input 간격이 기본값(outerStackView.spacing)으로 떨어지므로, label 뒤쪽 spacing을 직접 전환한다.
    private func updateLabelDescriptionSpacing() {
        outerStackView.setCustomSpacing(descriptionContainerView.isHidden ? BaseSpacing.Base.s10 : BaseSpacing.Base.s2, after: labelRowView)
    }

    // MARK: - State

    private func applyState() {
        textField.isEnabled = state != .disabled
        updateFieldStyle()
        updateHelperArea()
        updateCounterLabelContent()
    }

    // 외부 state, 포커스, 텍스트 유무를 조합해 렌더링 상태를 계산한다. UI를 직접 변경하지 않는다.
    private func resolvedState() -> ResolvedState {
        if state == .disabled { return .disabled }
        if textField.isFirstResponder { return .active }
        if !(textField.text?.isEmpty ?? true) { return .filled }
        return .default
    }

    // error는 default/active/filled 어디에나 겹칠 수 있는 독립 플래그. disabled에는 밀린다.
    private func isShowingError(for state: ResolvedState) -> Bool {
        state != .disabled && errorMessage != nil
    }

    // MARK: - Update

    private func updateFieldStyle() {
        let effectiveState = resolvedState()
        let showsError = isShowingError(for: effectiveState)
        textField.backgroundColor = effectiveState.backgroundColor(for: variant)
        textField.layer.borderWidth = (showsError || effectiveState.hasBorder) ? 1 : 0
        textField.layer.borderColor = showsError
            ? SemanticColor.Stroke.Danger.default.cgColor
            : effectiveState.borderColor
        textField.textColor = effectiveState.foregroundColor
        updatePlaceholder()
    }

    private func updatePlaceholder() {
        guard let placeholder else {
            textField.attributedPlaceholder = nil
            return
        }
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: Typography.body1.attributedStringAttributes(
                foregroundColor: resolvedState().placeholderColor(for: variant)
            )
        )
    }

    private func updateHelperArea() {
        let effectiveState = resolvedState()
        if isShowingError(for: effectiveState), let message = errorMessage {
            helperLabel.isHidden = true
            errorRowView.isHidden = false
            errorMessageLabel.text = message
            errorMessageLabel.setTypography(Typography.body3)
        } else if let helper = helperText {
            helperLabel.isHidden = false
            helperLabel.text = helper
            helperLabel.setTypography(Typography.body3, textColor: effectiveState.ghostColor)
            errorRowView.isHidden = true
        } else {
            helperLabel.isHidden = true
            errorRowView.isHidden = true
        }
        updateBottomRow()
    }

    private func updateCounterLabelContent() {
        guard let maxLength else { return }
        counterLabel.text = "\(textField.text?.count ?? 0)/\(maxLength)"
        counterLabel.setTypography(Typography.body3, textColor: resolvedState().ghostColor)
    }

    private func updateBottomRow() {
        bottomRowView.isHidden = helperLabel.isHidden && errorRowView.isHidden && counterLabel.isHidden
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
        counterLabel.setTypography(Typography.body3)
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
