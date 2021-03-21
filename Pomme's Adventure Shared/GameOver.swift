import SpriteKit

extension GameScene {
    var gameOverLabel: SKLabelNode? {
        children.first(where: { $0.name == NodeName.gameOverLabel.rawValue }) as? SKLabelNode
    }

    func gameOver() {
        removeAction(forKey: Ball.repeatAddBallActionKey)
        children
            .filter { $0.name == NodeName.ball.rawValue }
            .forEach { $0.removeFromParent() }
        isGameOver = true

        let label = SKLabelNode(text: "Game Over")
        label.fontSize = 60
        label.name = NodeName.gameOverLabel.rawValue
        label.zPosition = ZPosition.gameOverLabel.rawValue
        label.setScale(0.01)
        label.run(SKAction.sequence([
            SKAction.scale(to: 1, duration: 0.4),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.scale(to: 1, duration: 1),
                SKAction.scale(to: 0.8, duration: 1)
            ]))
        ]))
        label.position = CGPoint(x: ground.frame.midX, y: ground.frame.midY)
        addChild(label)
    }
}
