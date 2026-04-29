

import UIKit

public enum MDSState {
    case `default`
    case pressed
    case hover
    case disabled
}

public struct MDSSemanticColor {
    public struct Background {
        public struct Brand {
            public static func bold(state: MDSState = .default) -> UIColor {
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
            public static func subtle(state: MDSState) -> UIColor { .blue100 }
            public static let ghost = UIColor.clear
        }
        public struct Neutral { }
        public struct Danger {  }
    }
    public struct Foreground {  }
    public struct Stroke {  }
}
