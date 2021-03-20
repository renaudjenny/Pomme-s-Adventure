import SpriteKit

extension GameScene {
    static let repeatAddBallKey = "ActionRepeatAddBall"

    func repeatAddBall() {
        removeAction(forKey: GameScene.repeatAddBallKey)

        let durationBetweenBalls: TimeInterval = 2.0/TimeInterval(level) + 0.05
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: durationBetweenBalls),
            SKAction.run(addBall),
            SKAction.wait(forDuration: durationBetweenBalls),
        ])), withKey: GameScene.repeatAddBallKey)
    }

    private func addBall() {
        let ball = SKSpriteNode(imageNamed: Bool.random() ? "Red-apple" : "Green-apple")
        ball.size = CGSize(width: 20, height: 20)
        // Compute a safe area where the balls cannot pop, otherwise the game could be too difficult.
        let safeArea = player.safeArea

        let delta: (dx: CGFloat, dy: CGFloat) = [(1, 1), (-1, 1), (1, -1), (-1, -1)]
            .randomElement() ?? (.zero, .zero)
        let impulseFactor: CGFloat = 4
        let impulse = CGVector(dx: impulseFactor * delta.dx, dy: impulseFactor * delta.dy)

        while true {
            let position = CGPoint(
                x: CGFloat.random(in: ground.frame.minX...ground.frame.maxX - ball.size.width),
                y: CGFloat.random(in: ground.frame.minY...ground.frame.maxY - ball.size.height)
            )

            // Try again if the random position is inside the safe area
            guard !safeArea.contains(position) else {
                continue
            }

            ball.position = position
            ball.zPosition = ZPosition.ball.rawValue
            ball.name = NodeName.ball.rawValue

            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width/2)
            ball.physicsBody?.friction = 0
            ball.physicsBody?.restitution = 1
            ball.physicsBody?.linearDamping = 0
            ball.physicsBody?.angularDamping = 0
            ball.physicsBody?.categoryBitMask = BitMask.ballCategory.rawValue
            ball.physicsBody?.contactTestBitMask = BitMask.ballContactTest.rawValue

            addChild(ball)

            ball.run(SKAction.sequence([
                SKAction.fadeIn(withDuration: 1.4),
                SKAction.applyImpulse(impulse, duration: 0.5),
            ]))

            break
        }
    }

    func collisionBetween(ball: SKNode, object: SKNode) {
        if object === player.node {
            remove(ball: ball)
            gameOver()
        } else if object === hitArea {
            score += 100
            remove(ball: ball)
        } else if object === self {
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
                let dx: CGFloat = ground.frame.midX - ball.frame.midX > 0 ? 1 : -1
                runImpulse(impulse: CGVector(dx: dx, dy: 0))
            } else if abs(ball.physicsBody?.velocity.dy ?? 0) <= 1 {
                let dy: CGFloat = ground.frame.midY - ball.frame.midY > 0 ? 1 : -1
                runImpulse(impulse: CGVector(dx: 0, dy: dy))
            }
        }
    }

    private func remove(ball: SKNode) {
        let appleSlideAnimationTextures: [SKTexture] = [
            SKTexture(imageNamed: "Red-apple-sliced-1"),
            SKTexture(imageNamed: "Red-apple-sliced-2"),
        ]
        ball.physicsBody?.contactTestBitMask = 0
        ball.physicsBody?.categoryBitMask = 0
        ball.physicsBody?.velocity = .zero
        ball.run(SKAction.sequence([
            SKAction.animate(with: appleSlideAnimationTextures, timePerFrame: 0.2),
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.removeFromParent(),
        ]))
    }
}
