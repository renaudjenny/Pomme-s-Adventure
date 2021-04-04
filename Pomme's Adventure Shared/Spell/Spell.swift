import SpriteKit

struct Spell {
    var mana = Mana() { didSet { setScrolls() } }

    private var bubble = Bubble()

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
        switch mana.value {
        case 100...:
            waterScroll.alpha = 1
        default:
            waterScroll.alpha = 2/10
        }
        if bubble.isCast {
            waterScroll.alpha = 2/10
        }
    }

    mutating func castBubble(on player: Player) -> SKNode? {
        guard mana.value >= Bubble.mp,
              !bubble.isCast
        else { return nil }
        mana.value -= Bubble.mp
        bubble.cast(on: player)
        setScrolls()
        return bubble.node
    }

    func bubbleTouched() {
        bubble.hp -= 1
    }
}

final class Bubble {
    static let name = "spell_bubble"
    static let mp = 100
    private(set) var isCast = false
    private var isRemoving = false
    let node: SKSpriteNode = {
        let node = SKSpriteNode(color: .blue, size: CGSize(width: 60, height: 60))
        node.name = Bubble.name
        node.zPosition = ZPosition.spellBubble.rawValue
        node.alpha = 8/10

        node.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        node.physicsBody?.categoryBitMask = .spellBubbleCategoryBitMask

        return node
    }()

    var hp: Int = 0 {
        didSet {
            if hp <= 0 {
                remove()
                hp = 0
            }
        }
    }

    func cast(on player: Player) {
        guard !isCast
        else { return }
        node.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: player.node)]
        hp = 5
        isCast = true
    }

    private func remove() {
        guard !isRemoving
        else { return }
        isRemoving = true
        node.run(SKAction.sequence([
            SKAction.repeat(SKAction.sequence([
                SKAction.fadeAlpha(to: 2/10, duration: 0.1),
                SKAction.wait(forDuration: 1/4),
                SKAction.fadeAlpha(to: 8/10, duration: 0.1),
                SKAction.wait(forDuration: 1/4),
            ]), count: 4),
            SKAction.removeFromParent(),
        ]), completion: {
            [weak self] in
            self?.isCast = false
            self?.isRemoving = false
        })
    }
}

extension GameScene {
    func configureSpellScrolls() {
        spell.mana.configure(width: frame.size.width - 40)
        spell.mana.node.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        spell.waterScroll.position = CGPoint(x: frame.minX + 60, y: frame.minY + 60)

        addChild(spell.mana.node)
        addChild(spell.waterScroll)
    }
}
