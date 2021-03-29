import SpriteKit

extension GameScene {
    var gameOverLabel: SKLabelNode? {
        children.first(where: { $0.name == NodeName.gameOverLabel.rawValue }) as? SKLabelNode
    }

    func gameOver() {
        removeAction(forKey: Ball.repeatAddBallActionKey)
        removeAction(forKey: Bonus.repeatAddBonusActionKey)
        children
            .filter(isNodeToRemoveAfterGameOver)
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

    private func isNodeToRemoveAfterGameOver(_ node: SKNode) -> Bool {
        guard let name = node.name
        else { return false }
        return
            Ball.AppleType.names.contains(name)
            || Bonus.GemType.names.contains(name)
    }
}
