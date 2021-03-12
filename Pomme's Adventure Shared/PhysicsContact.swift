import SpriteKit

final class PhysicsContact: NSObject, SKPhysicsContactDelegate {
    let collisionBetween: (_ ball: SKNode, _ object: SKNode) -> Void

    init(collisionBetween: @escaping (_ ball: SKNode, _ object: SKNode) -> Void) {
        self.collisionBetween = collisionBetween
        super.init()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else { return }

        if nodeA.name == NodeName.ball.rawValue {
            collisionBetween(nodeA, nodeB)
        } else if nodeB.name == NodeName.ball.rawValue {
            collisionBetween(nodeB, nodeA)
        }
    }
}
