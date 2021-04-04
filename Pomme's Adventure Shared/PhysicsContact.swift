import SpriteKit

final class PhysicsContact: NSObject, SKPhysicsContactDelegate {
    let collisionBetweenMovePlayerAreaAndPlayer: () -> Void
    let borderNode: SKNode
    let groundNode: SKNode
    let playerNode: SKNode

    let ballHit: (SKNode) -> Void
    let playerTouched: (SKNode) -> Void
    let bubbleTouched: (SKNode) -> Void
    let bonusGathered: (SKNode) -> Void

    init(
        collisionBetweenMovePlayerAreaAndPlayer: @escaping () -> Void,
        borderNode: SKNode,
        groundNode: SKNode,
        playerNode: SKNode,
        ballHit: @escaping (SKNode) -> Void,
        playerTouched: @escaping (SKNode) -> Void,
        bubbleTouched: @escaping (SKNode) -> Void,
        bonusGathered: @escaping (SKNode) -> Void
    ) {
        self.collisionBetweenMovePlayerAreaAndPlayer = collisionBetweenMovePlayerAreaAndPlayer
        self.borderNode = borderNode
        self.groundNode = groundNode
        self.playerNode = playerNode
        self.ballHit = ballHit
        self.playerTouched = playerTouched
        self.bubbleTouched = bubbleTouched
        self.bonusGathered = bonusGathered
        super.init()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node
        else { return }

        switch (nodeA.name, nodeB.name) {
        case let (.some(ballName), _) where Ball.AppleType.names.contains(ballName):
            collisionBetween(ball: nodeA, object: nodeB)
        case let (_, .some(ballName)) where Ball.AppleType.names.contains(ballName):
            collisionBetween(ball: nodeB, object: nodeA)
        case (let .some(bonusName), _) where Bonus.GemType.names.contains(bonusName):
            bonusGathered(nodeA)
        case (_, let .some(bonusName)) where Bonus.GemType.names.contains(bonusName):
            bonusGathered(nodeB)
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
        } else if object.name == Bubble.name {
            bubbleTouched(ball)
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
    func ballHit(node: SKNode) {
        spell.mana.value += 10
        removeBall(node)
    }

    private func removeBall(_ node: SKNode) {
        guard let appleType = Ball.AppleType(node: node)
        else { return }
        score += appleType.points
        ball.remove(ball: node)
    }

    func playerTouched(by node: SKNode) {
        ball.remove(ball: node)
        gameOver()
    }

    func bubbleTouched(by node: SKNode) {
        removeBall(node)
        spell.bubbleTouched()
    }

    func bonusGathered(_ node: SKNode) {
        guard let gemType = Bonus.GemType(node: node)
        else { return }
        score += gemType.points
        node.removeFromParent()
    }
}
