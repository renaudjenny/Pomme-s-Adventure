import SpriteKit

struct Ball {
    static let repeatAddBallActionKey = "ActionRepeatAddBall"

    func repeatAddBall(level: Int, gameNode: SKNode, allowedAreas: [CGRect]) {
        gameNode.removeAction(forKey: Ball.repeatAddBallActionKey)

        let durationBetweenBalls: TimeInterval = 2.0/TimeInterval(level) + 0.05
        gameNode.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: durationBetweenBalls),
            SKAction.run { addBall(gameNode: gameNode, allowedAreas: allowedAreas) },
            SKAction.wait(forDuration: durationBetweenBalls),
        ])), withKey: Ball.repeatAddBallActionKey)
    }

    private func addBall(gameNode: SKNode, allowedAreas: [CGRect]) {
        let ball = SKSpriteNode(imageNamed: Bool.random() ? "Red-apple" : "Green-apple")
        ball.size = CGSize(width: 20, height: 20)

        let delta: (dx: CGFloat, dy: CGFloat) = [(1, 1), (-1, 1), (1, -1), (-1, -1)]
            .randomElement() ?? (.zero, .zero)
        let impulseFactor: CGFloat = 4
        let impulse = CGVector(dx: impulseFactor * delta.dx, dy: impulseFactor * delta.dy)

        let area = allowedAreas.randomElement() ?? .zero

        let position = CGPoint(
            x: CGFloat.random(in: area.minX...area.maxX - ball.size.width),
            y: CGFloat.random(in: area.minY...area.maxY - ball.size.height)
        )

        ball.position = position
        ball.zPosition = ZPosition.ball.rawValue
        ball.name = NodeName.ball.rawValue

        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.categoryBitMask = .ballCategoryBitMask
        ball.physicsBody?.collisionBitMask = .ballCollisionBitMask
        ball.physicsBody?.contactTestBitMask = .ballContactTestBitMask

        gameNode.addChild(ball)

        ball.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 1.4),
            SKAction.applyImpulse(impulse, duration: 0.5),
        ]))
    }

    func remove(ball: SKNode) {
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

extension GameScene {
    func repeatAddBall() {
        ball.repeatAddBall(level: level, gameNode: self, allowedAreas: allowedBallAppearAreas)
    }
}
