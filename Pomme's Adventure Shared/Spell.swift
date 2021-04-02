import SpriteKit

struct Spell {
    var bubble = Bubble()
}

struct Bubble {
    static let name = "spell_bubble"
    let node: SKSpriteNode = {
        let node = SKSpriteNode(color: .blue, size: CGSize(width: 60, height: 60))
        node.name = Self.name
        node.zPosition = ZPosition.spellBubble.rawValue
        node.alpha = 8/10

        node.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        node.physicsBody?.categoryBitMask = .spellBubbleCategoryBitMask

        return node
    }()

    var hp: Int = 0 {
        didSet { if hp <= 0 { remove() } }
    }

    mutating func cast(on player: Player) {
        node.constraints = [SKConstraint.distance(SKRange.init(constantValue: 0), to: player.node)]
        hp += 5
    }

    private func remove() {
        node.run(SKAction.sequence([
            SKAction.repeat(SKAction.sequence([
                SKAction.fadeAlpha(to: 2/10, duration: 0.1),
                SKAction.wait(forDuration: 1/4),
                SKAction.fadeAlpha(to: 8/10, duration: 0.1),
                SKAction.wait(forDuration: 1/4),
            ]), count: 4),
            SKAction.removeFromParent(),
        ]))
    }
}
