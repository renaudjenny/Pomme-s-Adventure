import SpriteKit

final class Bubble {
    static let name = "spell_bubble"
    static let mp = 200
    private(set) var isCast = false
    private var isRemoving = false
    let node: SKSpriteNode = {
        let node = SKSpriteNode(color: .blue, size: CGSize(width: 60, height: 60))
        node.name = Bubble.name
        node.zPosition = ZPosition.spellBubble.rawValue
        node.alpha = 8/10

        node.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        node.physicsBody?.isDynamic = false
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
