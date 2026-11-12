//
//  MDSSelectType.swift
//  MDS
//
//  Created by 최주리 on 11/12/26.
//

public extension MDSSelect {

    enum SelectType {
        /// 항목을 탭하면 값이 채워지고 메뉴가 바로 닫힌다. 메뉴에는 선택 표시가 남지 않는다.
        case single
        /// 탭할 때마다 체크가 토글되고 메뉴는 열린 채로 남는다. `.text`, `.checkbox` 메뉴에서만 쓸 수 있다.
        case multiple
    }

    /// 열리는 메뉴의 종류와 그 항목. 각 Menu의 `Item`을 그대로 쓴다.
    /// Text, Checkbox 항목의 `isChecked`는 처음 선택 상태가 된다.
    enum MenuType {
        case text([MDSTextMenu.Item])
        case checkbox([MDSCheckboxMenu.Item])
        /// `.single`만 쓸 수 있다.
        case icon([MDSIconMenu.Item])
        /// `.single`만 쓸 수 있다.
        case userList([MDSUserListMenu.Item])
    }
}
