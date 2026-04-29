//
//  BaseColor.swift
//  MDS
//
//  Created by 최주리 on 4/21/26.
//


// 직접 사용하지 않으니 internal로 선언

import UIKit

// MARK: - Base Color (Internal Only)

internal extension UIColor {
    // Gray
    static var gray0: UIColor { return UIColor(named: "gray0", in: .module, compatibleWith: nil)! }
    static var gray10: UIColor { return UIColor(named: "gray10", in: .module, compatibleWith: nil)! }
    static var gray20: UIColor { return UIColor(named: "gray20", in: .module, compatibleWith: nil)! }
    static var gray30: UIColor { return UIColor(named: "gray30", in: .module, compatibleWith: nil)! }
    static var gray50: UIColor { return UIColor(named: "gray50", in: .module, compatibleWith: nil)! }
    static var gray100: UIColor { return UIColor(named: "gray100", in: .module, compatibleWith: nil)! }
    static var gray200: UIColor { return UIColor(named: "gray200", in: .module, compatibleWith: nil)! }
    static var gray300: UIColor { return UIColor(named: "gray300", in: .module, compatibleWith: nil)! }
    static var gray400: UIColor { return UIColor(named: "gray400", in: .module, compatibleWith: nil)! }
    static var gray500: UIColor { return UIColor(named: "gray500", in: .module, compatibleWith: nil)! }
    static var gray600: UIColor { return UIColor(named: "gray600", in: .module, compatibleWith: nil)! }
    static var gray700: UIColor { return UIColor(named: "gray700", in: .module, compatibleWith: nil)! }
    static var gray800: UIColor { return UIColor(named: "gray800", in: .module, compatibleWith: nil)! }
    static var gray900: UIColor { return UIColor(named: "gray900", in: .module, compatibleWith: nil)! }
    static var gray950: UIColor { return UIColor(named: "gray950", in: .module, compatibleWith: nil)! }
    
    // Blue
    static var blue50: UIColor { UIColor(named: "blue50", in: .module, compatibleWith: nil)! }
    static var blue100: UIColor { UIColor(named: "blue100", in: .module, compatibleWith: nil)! }
    static var blue200: UIColor { UIColor(named: "blue200", in: .module, compatibleWith: nil)! }
    static var blue300: UIColor { UIColor(named: "blue300", in: .module, compatibleWith: nil)! }
    static var blue400: UIColor { UIColor(named: "blue400", in: .module, compatibleWith: nil)! }
    static var blue500: UIColor { UIColor(named: "blue500", in: .module, compatibleWith: nil)! }
    static var blue600: UIColor { UIColor(named: "blue600", in: .module, compatibleWith: nil)! }
    static var blue700: UIColor { UIColor(named: "blue700", in: .module, compatibleWith: nil)! }
    static var blue800: UIColor { UIColor(named: "blue800", in: .module, compatibleWith: nil)! }
    static var blue900: UIColor { UIColor(named: "blue900", in: .module, compatibleWith: nil)! }
    static var blue950: UIColor { UIColor(named: "blue950", in: .module, compatibleWith: nil)! }
    
    // Green
    static var green50: UIColor { UIColor(named: "green50", in: .module, compatibleWith: nil)! }
    static var green100: UIColor { UIColor(named: "green100", in: .module, compatibleWith: nil)! }
    static var green200: UIColor { UIColor(named: "green200", in: .module, compatibleWith: nil)! }
    static var green300: UIColor { UIColor(named: "green300", in: .module, compatibleWith: nil)! }
    static var green400: UIColor { UIColor(named: "green400", in: .module, compatibleWith: nil)! }
    static var green500: UIColor { UIColor(named: "green500", in: .module, compatibleWith: nil)! }
    static var green600: UIColor { UIColor(named: "green600", in: .module, compatibleWith: nil)! }
    static var green700: UIColor { UIColor(named: "green700", in: .module, compatibleWith: nil)! }
    static var green800: UIColor { UIColor(named: "green800", in: .module, compatibleWith: nil)! }
    static var green900: UIColor { UIColor(named: "green900", in: .module, compatibleWith: nil)! }
    static var green950: UIColor { UIColor(named: "green950", in: .module, compatibleWith: nil)! }
    
    // orange
    static var orange50: UIColor { UIColor(named: "orange50", in: .module, compatibleWith: nil)! }
    static var orange100: UIColor { UIColor(named: "orange100", in: .module, compatibleWith: nil)! }
    static var orange200: UIColor { UIColor(named: "orange200", in: .module, compatibleWith: nil)! }
    static var orange300: UIColor { UIColor(named: "orange300", in: .module, compatibleWith: nil)! }
    static var orange400: UIColor { UIColor(named: "orange400", in: .module, compatibleWith: nil)! }
    static var orange500: UIColor { UIColor(named: "orange500", in: .module, compatibleWith: nil)! }
    static var orange600: UIColor { UIColor(named: "orange600", in: .module, compatibleWith: nil)! }
    static var orange700: UIColor { UIColor(named: "orange700", in: .module, compatibleWith: nil)! }
    static var orange800: UIColor { UIColor(named: "orange800", in: .module, compatibleWith: nil)! }
    static var orange900: UIColor { UIColor(named: "orange900", in: .module, compatibleWith: nil)! }
    static var orange950: UIColor { UIColor(named: "orange950", in: .module, compatibleWith: nil)! }
    
    // Red
    static var red50: UIColor { UIColor(named: "red50", in: .module, compatibleWith: nil)! }
    static var red100: UIColor { UIColor(named: "red100", in: .module, compatibleWith: nil)! }
    static var red200: UIColor { UIColor(named: "red200", in: .module, compatibleWith: nil)! }
    static var red300: UIColor { UIColor(named: "red300", in: .module, compatibleWith: nil)! }
    static var red400: UIColor { UIColor(named: "red400", in: .module, compatibleWith: nil)! }
    static var red500: UIColor { UIColor(named: "red500", in: .module, compatibleWith: nil)! }
    static var red600: UIColor { UIColor(named: "red600", in: .module, compatibleWith: nil)! }
    static var red700: UIColor { UIColor(named: "red700", in: .module, compatibleWith: nil)! }
    static var red800: UIColor { UIColor(named: "red800", in: .module, compatibleWith: nil)! }
    static var red900: UIColor { UIColor(named: "red900", in: .module, compatibleWith: nil)! }
    static var red950: UIColor { UIColor(named: "red950", in: .module, compatibleWith: nil)! }
    
    // Yellow
    static var yellow50: UIColor { UIColor(named: "yellow50", in: .module, compatibleWith: nil)! }
    static var yellow100: UIColor { UIColor(named: "yellow100", in: .module, compatibleWith: nil)! }
    static var yellow200: UIColor { UIColor(named: "yellow200", in: .module, compatibleWith: nil)! }
    static var yellow300: UIColor { UIColor(named: "yellow300", in: .module, compatibleWith: nil)! }
    static var yellow400: UIColor { UIColor(named: "yellow400", in: .module, compatibleWith: nil)! }
    static var yellow500: UIColor { UIColor(named: "yellow500", in: .module, compatibleWith: nil)! }
    static var yellow600: UIColor { UIColor(named: "yellow600", in: .module, compatibleWith: nil)! }
    static var yellow700: UIColor { UIColor(named: "yellow700", in: .module, compatibleWith: nil)! }
    static var yellow800: UIColor { UIColor(named: "yellow800", in: .module, compatibleWith: nil)! }
    static var yellow900: UIColor { UIColor(named: "yellow900", in: .module, compatibleWith: nil)! }
    static var yellow950: UIColor { UIColor(named: "yellow950", in: .module, compatibleWith: nil)! }
}
