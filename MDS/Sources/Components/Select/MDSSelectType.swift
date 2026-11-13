//
//  MDSSelectType.swift
//  MDS
//
//  Created by 최주리 on 11/12/26.
//

public extension MDSSelect {

    /// 선택 방식과 열리는 메뉴 (Figma Select의 Type 속성).
    /// 선택 방식마다 쓸 수 있는 메뉴만 받아서, 불가능한 조합(예: 다중 선택 + Icon 메뉴)은 컴파일 단계에서 막는다.
    enum SelectType {
        /// 항목을 탭하면 값이 채워지고 메뉴가 바로 닫힌다. 메뉴에는 선택 표시가 남지 않는다.
        case single(SingleMenu)
        /// 탭할 때마다 체크가 토글되고 메뉴는 열린 채로 남는다.
        case multiple(MultipleMenu)
    }

    /// 단일 선택에서 쓸 수 있는 메뉴. 각 Menu의 `Item`을 그대로 쓴다.
    enum SingleMenu {
        /// 항목의 `isChecked`가 처음 선택 상태가 된다. 체크된 항목이 여러 개면 가장 앞의 하나만 남는다.
        case text([MDSTextMenu.Item])
        case icon([MDSIconMenu.Item])
        case userList([MDSUserListMenu.Item])
    }

    /// 다중 선택에서 쓸 수 있는 메뉴. 항목의 `isChecked`가 처음 선택 상태가 된다.
    enum MultipleMenu {
        case text([MDSTextMenu.Item])
        case checkbox([MDSCheckboxMenu.Item])
    }
}
