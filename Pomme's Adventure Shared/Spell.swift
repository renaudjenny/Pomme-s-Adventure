import SpriteKit

struct Spell {
    var mp = 0 {
        didSet { setScrolls() }
    }

    var bubble = Bubble()

    let waterScroll: SKShapeNode = {
        let node = SKShapeNode(circleOfRadius: 25)
        node.fillColor = .blue

        let label = SKLabelNode(text: "100")
        label.verticalAlignmentMode = .center
        label.fontSize = 20
        node.addChild(label)
        return node
    }()

    private func setScrolls() {
        switch mp {
        case 100...:
            waterScroll.alpha = 1
        default:
            waterScroll.alpha = 2/10
        }
    }
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

extension GameScene {
    func configureSpellScrolls() {
        spell.waterScroll.position = CGPoint(x: frame.minX + 60, y: frame.minY + 60)

        addChild(spell.waterScroll)
    }
}
