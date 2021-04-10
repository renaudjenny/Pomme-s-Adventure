import SpriteKit

struct Spell {
    var mana = Mana() { didSet { setScrolls() } }

    private var bubble = Bubble()
    private var fireballs = Fireballs()

    let waterScroll: SKShapeNode = {
        let node = SKShapeNode(circleOfRadius: 25)
        node.fillColor = .blue

        let label = SKLabelNode(text: "200")
        label.verticalAlignmentMode = .center
        label.fontSize = 20
        node.addChild(label)
        return node
    }()

    let fireScroll: SKShapeNode = {
        let node = SKShapeNode(circleOfRadius: 25)
        node.fillColor = .red

        let label = SKLabelNode(text: "300")
        label.verticalAlignmentMode = .center
        label.fontSize = 20
        node.addChild(label)
        return node
    }()

    private func setScrolls() {
        switch mana.value {
        case 200..<300:
            waterScroll.alpha = 1
        case 300...:
            waterScroll.alpha = 1
            fireScroll.alpha = 1
        default:
            waterScroll.alpha = 2/10
            fireScroll.alpha = 2/10
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

    mutating func castFireballs() {
        guard mana.value >= Fireballs.mp,
              !fireballs.isCast
        else { return }
        mana.value -= Fireballs.mp
        fireballs.cast()
        setScrolls()
    }

    func fire(player: Player, to direction: Direction, addChild: @escaping (SKNode) -> Void) {
        guard fireballs.isCast
        else { return }
        fireballs.fire(player: player, to: direction, addChild: addChild)
    }
}

extension GameScene {
    func configureSpellScrolls() {
        spell.mana.configure(width: frame.size.width - 40)
        spell.mana.node.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        spell.waterScroll.position = CGPoint(x: frame.minX + 60, y: frame.minY + 60)
        spell.fireScroll.position = CGPoint(x: frame.midX, y: frame.minY + 60)

        addChild(spell.mana.node)
        addChild(spell.waterScroll)
        addChild(spell.fireScroll)
    }
}
