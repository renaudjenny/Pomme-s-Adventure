import SpriteKit

enum Spell {
    case bubble

    var name: String {
        switch self {
        case .bubble: return "spell_bubble"
        }
    }

    static func castBubble(on player: Player) -> SKSpriteNode {
        let node = SKSpriteNode(color: .blue, size: CGSize(width: 60, height: 60))
        node.name = Self.bubble.name
        node.zPosition = ZPosition.spellBubble.rawValue
        node.alpha = 8/10

        node.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        node.physicsBody?.categoryBitMask = .spellBubbleCategoryBitMask
        node.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: player.node)]

        return node
    }
}
