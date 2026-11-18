//
//  SwiftUIRootHostingController.swift
//  MDSStoryBook
//
//  Created by 이나연 on 11/16/26.
//

import SwiftUI
import UIKit

/// SwiftUI 카탈로그(`NavigationStack`)를 탭바의 한 탭으로 올리는 호스팅 컨트롤러.
/// SwiftUI 쪽이 자체 내비게이션 바를 가진다.
final class SwiftUIRootHostingController: UIHostingController<SwiftUIRootView> {

    init() {
        super.init(rootView: SwiftUIRootView())
    }

    @available(*, unavailable)
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
