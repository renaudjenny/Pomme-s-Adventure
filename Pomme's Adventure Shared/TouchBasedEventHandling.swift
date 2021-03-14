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

        if player.frame.insetBy(dx: -50, dy: -50).contains(touchLocation) {
            guard movePlayerArea == nil
            else { return }
            let movePlayerArea = SKSpriteNode(color: .gray, size: CGSize(width: 44, height: 44))
            movePlayerArea.name = NodeName.movePlayerArea.rawValue
            movePlayerArea.position = touchLocation
            addChild(movePlayerArea)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: self)
        else { return }

        if let movePlayerArea = movePlayerArea {
            if !player.frame.intersects(movePlayerArea.frame) {
                movePlayer(toLocation: touchLocation)

                let textures: [SKTexture] = [SKTexture(imageNamed: "Pomme-move"), SKTexture(imageNamed: "Pomme-move-2")]
                player.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.4)), withKey: "MoveAnimationAction")
            }
            movePlayerArea.run(SKAction.move(to: touchLocation, duration: 0.1))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopMovePlayer()
        movePlayerArea?.run(SKAction.removeFromParent())

        guard let touchLocation = touches.first?.location(in: self)
        else { return }

        // If Game Over Label is present, that means the game is over
        if gameOverLabel?.frame.contains(touchLocation) ?? false {
            // Start new game
            gameOverLabel?.removeFromParent()
            isGameOver = false
            player.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.6),
                SKAction.move(to: CGPoint(x: ground.frame.midX, y: ground.frame.midY), duration: 0.1),
                SKAction.fadeIn(withDuration: 0.6)
            ]))
            score = 0
            level = 1
            repeatAddBall()
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopMovePlayer()
        movePlayerArea?.run(SKAction.removeFromParent())
    }
}
#endif

