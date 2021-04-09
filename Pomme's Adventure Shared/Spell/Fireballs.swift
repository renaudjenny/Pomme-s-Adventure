import SpriteKit

final class Fireballs {
    static let name = "spell_fireballs"
    static let mp = 300
    private(set) var isCast = false

    func fireballNode() -> SKSpriteNode {
        let node = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 30))
        node.name = Fireballs.name
        node.zPosition = ZPosition.spellFireballs.rawValue

        node.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        node.physicsBody?.categoryBitMask = .hitAreaCategoryBitMask
        node.physicsBody?.collisionBitMask = .hitAreaCollisionBitMask
        node.physicsBody?.contactTestBitMask = .hitAreaContactTestBitMask

        return node
    }

    var count: Int = 0 {
        didSet {
            if count <= 0 {
                count = 0
                isCast = false
            }
        }
    }

    func cast() {
        isCast = true
        count = 10
    }

    func fire(player: Player, to direction: Direction, addChild: (SKNode) -> Void) {
        let mainFireball = fireballNode()
        mainFireball.position = player.node.position
        addChild(mainFireball)

        let (dx, dy) = direction.dxdy
        let impulse = CGVector(dx: dx, dy: dy)
        mainFireball.run(SKAction.sequence([
            SKAction.applyImpulse(impulse, duration: 1/2),
            SKAction.wait(forDuration: 4),
            SKAction.removeFromParent(),
        ]))
        count -= 1
    }
}
