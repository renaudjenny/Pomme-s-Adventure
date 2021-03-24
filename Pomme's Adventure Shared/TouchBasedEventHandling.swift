#if os(iOS) || os(tvOS)
import SpriteKit

extension GameScene {
    var movePlayerArea: SKSpriteNode? {
        children.first(where: { $0.name == NodeName.movePlayerArea.rawValue }) as? SKSpriteNode
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: self),
              !isGameOver
        else { return }

        hit(location: touchLocation)

        if player.node.frame.insetBy(dx: -50, dy: -50).contains(touchLocation) {
            guard movePlayerArea == nil
            else { return }
            let movePlayerArea = SKSpriteNode(color: .gray, size: CGSize(width: 44, height: 44))
            movePlayerArea.name = NodeName.movePlayerArea.rawValue
            movePlayerArea.position = touchLocation
            movePlayerArea.physicsBody = SKPhysicsBody(circleOfRadius: 22)
            movePlayerArea.physicsBody?.categoryBitMask = .movePlayerAreaCategoryBitMask
            movePlayerArea.physicsBody?.isDynamic = false
            addChild(movePlayerArea)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: self),
              let movePlayerArea = movePlayerArea
        else { return }

        if !player.node.frame.intersects(movePlayerArea.frame) {
            player.move(toLocation: touchLocation)
        }
        movePlayerArea.run(SKAction.move(to: touchLocation, duration: 0.1))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopMoving()
        movePlayerArea?.run(SKAction.removeFromParent())

        guard let touchLocation = touches.first?.location(in: self)
        else { return }

        // If Game Over Label is present, that means the game is over
        if gameOverLabel?.frame.contains(touchLocation) ?? false {
            // Start new game
            gameOverLabel?.removeFromParent()
            isGameOver = false
            player.fall(resurrectionPosition: center)
            score = 0
            level = 1
            repeatAddBall()
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopMoving()
        movePlayerArea?.run(SKAction.removeFromParent())
    }
}
#endif

