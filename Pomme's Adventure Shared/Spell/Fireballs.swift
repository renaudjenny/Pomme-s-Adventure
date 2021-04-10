import SpriteKit

final class Fireballs {
    static let name = "spell_fireballs"
    static let mp = 300
    private(set) var isCast = false

    func fireballNode() -> SKEmitterNode {
        guard let node = SKEmitterNode(fileNamed: "Fire.sks")
        else { fatalError("Cannot load Fire.sks file for Fireball Node") }
        node.name = Fireballs.name
        node.zPosition = ZPosition.spellFireballs.rawValue

        node.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        node.physicsBody?.categoryBitMask = .fireballCategoryBitMask
        node.physicsBody?.collisionBitMask = .fireballCollisionBitMask
        node.physicsBody?.contactTestBitMask = .fireballContactTestBitMask

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
        count = 100
    }

    func fire(player: Player, to direction: Direction, addChild: (SKNode) -> Void) {
        for i in -1...1 {
            let fireball = fireballNode()
            fireball.position = player.node.position
            addChild(fireball)

            let angle = direction.angle + .pi/6 * CGFloat(i)
            let dx = sin(angle)
            let dy = -cos(angle)
            let factor: CGFloat = 60
            let impulse = CGVector(dx: dx * factor, dy: dy * factor)
            fireball.zRotation = angle
            fireball.run(SKAction.sequence([
                SKAction.applyImpulse(impulse, duration: 1/2),
                SKAction.wait(forDuration: 1),
                SKAction.fadeOut(withDuration: 1/2),
                SKAction.removeFromParent(),
            ]))
        }
        count -= 1
    }
}
