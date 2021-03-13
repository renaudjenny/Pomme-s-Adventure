import SpriteKit

final class PhysicsContact: NSObject, SKPhysicsContactDelegate {
    let collisionBetweenBall: (_ ball: SKNode, _ object: SKNode) -> Void

    init(collisionBetweenBall: @escaping (_ ball: SKNode, _ object: SKNode) -> Void) {
        self.collisionBetweenBall = collisionBetweenBall
        super.init()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else { return }

        switch (nodeA.name, nodeB.name) {
        case (NodeName.ball.rawValue, _):
            collisionBetweenBall(nodeA, nodeB)
        case (_, NodeName.ball.rawValue):
            collisionBetweenBall(nodeB, nodeA)
        default: break
        }
    }
}
