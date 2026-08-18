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

    // MARK: - Callbacks

    /// 사용자 입력으로 텍스트가 바뀔 때 호출된다. text 프로퍼티로 직접 대입한 경우에는 호출되지 않는다.
    /// clear 버튼을 눌러 비워진 경우에도 빈 문자열로 호출된다.
    public var onTextChanged: ((String) -> Void)?
    
    public var onEditingBegin: (() -> Void)?
    
    public var onEditingEnd: (() -> Void)?
    
    /// 키보드의 search(리턴) 키를 눌렀을 때 호출된다.
    public var onSearchTapped: ((String) -> Void)?
    
    public var onClearTapped: (() -> Void)?

    // MARK: - Keyboard

    public var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set {
            textField.keyboardType = newValue
            reloadInputViewsIfEditing()
        }
    }
    public var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set {
            textField.returnKeyType = newValue
            reloadInputViewsIfEditing()
        }
    }
    public var textContentType: UITextContentType? {
        get { textField.textContentType }
        set {
            textField.textContentType = newValue
            reloadInputViewsIfEditing()
        }
    }
    public var autocapitalizationType: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set {
            textField.autocapitalizationType = newValue
            reloadInputViewsIfEditing()
        }
    }
    public var autocorrectionType: UITextAutocorrectionType {
        get { textField.autocorrectionType }
        set {
            textField.autocorrectionType = newValue
            reloadInputViewsIfEditing()
        }
    }
    /// UIResponder.inputAccessoryView와 이름이 겹치지 않도록 별도 이름으로 내부 필드에 전달한다.
    public var keyboardAccessoryView: UIView? {
        get { textField.inputAccessoryView }
        set {
            textField.inputAccessoryView = newValue
            reloadInputViewsIfEditing()
        }
    }

    /// UIKit은 first responder가 되는 시점에 입력 뷰를 구성하고 이후 다시 묻지 않는다.
    /// 편집 중에 키보드 설정을 바꾸면 화면에 반영되지 않으므로 즉시 다시 구성하도록 요청한다.
    private func reloadInputViewsIfEditing() {
        guard textField.isFirstResponder else { return }
        textField.reloadInputViews()
    }

    // MARK: - First Responder

    public override var canBecomeFirstResponder: Bool { textField.canBecomeFirstResponder }

    public override var isFirstResponder: Bool { textField.isFirstResponder }

    @discardableResult
    public override func becomeFirstResponder() -> Bool { textField.becomeFirstResponder() }

    @discardableResult
    public override func resignFirstResponder() -> Bool { textField.resignFirstResponder() }

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
        field.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.bold)
        field.tintColor = SemanticColor.Fg.Neutral.bold
        field.returnKeyType = .search
        return field
    }()

    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(MDSIcon.xCircleFilled.image.withRenderingMode(.alwaysTemplate), for: .normal)
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
        textField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        addSubview(searchIconView)
        addSubview(textField)
        addSubview(clearButton)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 46),

            searchIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: BaseSpacing.Base.s14),
            searchIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIconView.widthAnchor.constraint(equalToConstant: 20),
            searchIconView.heightAnchor.constraint(equalToConstant: 20),

            textField.leadingAnchor.constraint(equalTo: searchIconView.trailingAnchor, constant: BaseSpacing.Base.s8),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -BaseSpacing.Base.s8),

            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -BaseSpacing.Base.s14),
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

    // 붙여넣기/자동완성/받아쓰기까지 포함해 사용자 입력이 확정된 뒤 호출된다.
    @objc private func handleEditingChanged() {
        updateAppearance()
        onTextChanged?(textField.text ?? "")
    }

    @objc private func clearButtonTapped() {
        textField.text = nil
        updateAppearance()
        // clear도 사용자 조작에 의한 텍스트 변경이므로 onTextChanged를 함께 호출한다.
        onTextChanged?("")
        onClearTapped?()
    }
}

// MARK: - UITextFieldDelegate

extension MDSSearchField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateAppearance()
        onEditingBegin?()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateAppearance()
        onEditingEnd?()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        onSearchTapped?(textField.text ?? "")
        return true
    }
}
