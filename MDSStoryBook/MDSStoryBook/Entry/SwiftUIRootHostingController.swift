//
//  SwiftUIRootHostingController.swift
//  MDSStoryBook
//
//  Created by 이나연 on 11/16/26.
//

import SwiftUI
import UIKit

/// SwiftUI 카탈로그(`NavigationStack`)를 UIKit 내비게이션 위에 올리는 호스팅 컨트롤러.
/// SwiftUI 쪽이 자체 내비게이션 바를 가지므로 이 화면에서는 UIKit 바를 숨기고,
/// 진입 화면(`FrameworkSelectViewController`)으로 돌아가는 동작은 `onClose`로 SwiftUI에 넘긴다.
final class SwiftUIRootHostingController: UIHostingController<SwiftUIRootView> {

    init() {
        // self를 캡처하려면 super.init 이후여야 하므로, 빈 클로저로 먼저 초기화한 뒤 교체한다.
        super.init(rootView: SwiftUIRootView(onClose: {}))
        rootView = SwiftUIRootView(onClose: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
    }

    @available(*, unavailable)
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
