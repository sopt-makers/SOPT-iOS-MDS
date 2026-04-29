//
//  MDSSemanticColor.swift
//  MDS
//
//  Created by 최주리 on 4/30/26.
//

import UIKit

public struct MDSSemanticColor {
    public struct Background {
        public struct Brand {
            public static func bold(state: SemanticColorState = .default) -> UIColor {
                switch state {
                case .default:
                        .blue100
                case .pressed:
                        .blue100
                case .hover:
                        .blue100
                case .disabled:
                        .blue100
                }
            }
            public static func subtle(state: SemanticColorState) -> UIColor { .blue100 }
            public static let ghost = UIColor.clear
        }
        public struct Neutral { }
        public struct Danger {  }
    }
    public struct Foreground {  }
    public struct Stroke {  }
}
