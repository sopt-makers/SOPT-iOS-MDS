//
//  MDSSearchField.swift
//  MDS
//

import UIKit

public final class MDSSearchField: UIView {

    // MARK: - Nested Types

    public enum Variant {
        case `default`
        case bold
    }

    private enum State {
        case `default`
        case active
        case filled

        func backgroundColor(for variant: MDSSearchField.Variant) -> UIColor {
            switch variant {
            case .default: return SemanticColor.Bg.Layer.default
            case .bold: return SemanticColor.Bg.Neutral.ghost
            }
        }

        var hasBorder: Bool { self == .active }

        var borderColor: CGColor? {
            self == .active ? SemanticColor.Stroke.Neutral.Default.focused.cgColor : nil
        }
    }

    // MARK: - Public Properties

    private let placeholder: String?

    public var text: String? {
        get { textField.text }
        set {
            textField.text = newValue
            updateAppearance()
        }
    }

    // MARK: - Private Properties

    private let variant: Variant

    // MARK: - Subviews

    private let searchIconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = MDSIcon.searchOutlined.image.withRenderingMode(.alwaysTemplate)
        view.tintColor = SemanticColor.Fg.Neutral.default
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .none
        field.setTypography(Typography.body1)
        field.textColor = SemanticColor.Fg.Neutral.bold
        field.returnKeyType = .search
        return field
    }()

    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(MDSIcon.xCloseOutlined.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = SemanticColor.Fg.Neutral.bold
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    // MARK: - Init

    public init(variant: Variant = .default, placeholder: String? = nil) {
        self.variant = variant
        self.placeholder = placeholder
        
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        initialAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupUI() {
        layer.cornerRadius = BaseRadius.Base.r10
        layer.masksToBounds = true

        textField.delegate = self
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        addSubview(searchIconView)
        addSubview(textField)
        addSubview(clearButton)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),

            searchIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            searchIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 20),
            searchIconView.heightAnchor.constraint(equalToConstant: 20),

            textField.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: 8),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -8),

            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 20),
            clearButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    // init 시 한 번 호출. stored properties 값을 기반으로 초기 뷰 상태를 세팅한다.
    private func initialAppearance() {
        if let placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: Typography.body1.attributedStringAttributes(
                    foregroundColor: SemanticColor.Fg.Neutral.ghost
                )
            )
        }
        updateAppearance()
    }

    // MARK: - State

    // 포커스, 텍스트 유무를 조합해 렌더링 상태를 계산한다. UI를 직접 변경하지 않는다.
    private func resolvedState() -> State {
        if textField.isFirstResponder { return .active }
        if !(textField.text?.isEmpty ?? true) { return .filled }
        return .default
    }

    // MARK: - Update

    private func updateAppearance() {
        let state = resolvedState()
        backgroundColor = state.backgroundColor(for: variant)
        layer.borderWidth = state.hasBorder ? 1 : 0
        layer.borderColor = state.borderColor
        clearButton.isHidden = state != .active || (textField.text?.isEmpty ?? true)
    }

    // MARK: - Actions

    @objc private func clearButtonTapped() {
        textField.text = nil
        updateAppearance()
    }
}

// MARK: - UITextFieldDelegate

extension MDSSearchField: UITextFieldDelegate {

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        clearButton.isHidden = newText.isEmpty
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateAppearance()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateAppearance()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
