//
//  UIImageView+Icon.swift
//  MDS
//

import UIKit

extension UIImageView {
    /// 아이콘과 색을 설정합니다.
    /// `tint`가 `.automatic`이면 template으로 변환해 `tintColor`를 적용하고, `.original`이면 asset 원본 색상을 유지합니다.
    /// 양쪽 모두 renderingMode를 명시적으로 지정하므로 asset catalog 설정과 무관하게 결과가 같습니다.
    /// icon이 nil이면 imageView를 숨겨 stack에서 자리를 차지하지 않게 합니다.
    func setIcon(_ icon: MDSIcon?, tint: MDSIcon.Tint = .automatic, tintColor: UIColor) {
        guard let icon else {
            image = nil
            isHidden = true
            return
        }

        isHidden = false

        switch tint {
        case .automatic:
            image = icon.image.withRenderingMode(.alwaysTemplate)
            self.tintColor = tintColor
        case .original:
            image = icon.image.withRenderingMode(.alwaysOriginal)
        }
    }
}
