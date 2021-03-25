import SpriteKit

final class PhysicsContact: NSObject, SKPhysicsContactDelegate {
    let collisionBetweenMovePlayerAreaAndPlayer: () -> Void
    let borderNode: SKNode
    let groundNode: SKNode
    let playerNode: SKNode

    let ballHit: (SKNode) -> Void
    let playerTouched: (SKNode) -> Void

    init(
        collisionBetweenMovePlayerAreaAndPlayer: @escaping () -> Void,
        borderNode: SKNode,
        groundNode: SKNode,
        playerNode: SKNode,
        ballHit: @escaping (SKNode) -> Void,
        playerTouched: @escaping (SKNode) -> Void
    ) {
        self.collisionBetweenMovePlayerAreaAndPlayer = collisionBetweenMovePlayerAreaAndPlayer
        self.borderNode = borderNode
        self.groundNode = groundNode
        self.playerNode = playerNode
        self.ballHit = ballHit
        self.playerTouched = playerTouched
        super.init()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else { return }

        switch (nodeA.name, nodeB.name) {
        case (NodeName.ball.rawValue, _):
            collisionBetween(ball: nodeA, object: nodeB)
        case (_, NodeName.ball.rawValue):
            collisionBetween(ball: nodeB, object: nodeA)
        #if os(iOS) || os(tvOS)
        case (NodeName.movePlayerArea.rawValue, _),
             (_, NodeName.movePlayerArea.rawValue):
            collisionBetweenMovePlayerAreaAndPlayer()
        #endif
        default: break
        }
    }

    func collisionBetween(ball: SKNode, object: SKNode) {
        if object === playerNode {
            playerTouched(ball)
        } else if object.name == NodeName.hitArea.rawValue {
            ballHit(ball)
        } else if object === borderNode {
            // balls can be stuck to the border if they haven't enough velocity
            // In this case, let's them bonce in direction to the center with
            // enough Velocity to bounce again

            func runImpulse(impulse: CGVector) {
                ball.run(SKAction.sequence([
                    SKAction.scale(to: 1.2, duration: 1),
                    SKAction.group([
                        SKAction.scale(to: 1, duration: 1),
                        SKAction.applyImpulse(impulse, duration: 0.2)
                    ]),
                ]))
            }

            if abs(ball.physicsBody?.velocity.dx ?? 0) <= 1 {
                let dx: CGFloat = groundNode.frame.midX - ball.frame.midX > 0 ? 1 : -1
                runImpulse(impulse: CGVector(dx: dx, dy: 0))
            } else if abs(ball.physicsBody?.velocity.dy ?? 0) <= 1 {
                let dy: CGFloat = groundNode.frame.midY - ball.frame.midY > 0 ? 1 : -1
                runImpulse(impulse: CGVector(dx: 0, dy: dy))
            }
        }
    }
}

extension GameScene {
    func removeBall(_ node: SKNode) {
        score += 100
        ball.remove(ball: node)
    }

    func playerTouched(by node: SKNode) {
        ball.remove(ball: node)
        gameOver()
    }
}
