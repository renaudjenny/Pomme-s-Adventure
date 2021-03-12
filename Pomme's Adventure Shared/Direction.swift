import SceneKit

enum Direction {
    case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left

    var angle: CGFloat {
        switch self {
        case .topLeft: return 5 * .pi/4
        case .top: return .pi
        case .topRight: return 3 * .pi/4
        case .right: return .pi/2
        case .bottomRight: return .pi/4
        case .bottom: return 0
        case .bottomLeft: return 7 * .pi/4
        case .left: return 3 * .pi/2
        }
    }
}
