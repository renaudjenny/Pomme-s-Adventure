import SpriteKit

extension GameScene {
    var hitArea: SKSpriteNode? {
        children.first(where: { $0.name == NodeName.hitArea.rawValue }) as? SKSpriteNode
    }

    func hit(location: CGPoint) {
        hit(direction: playerDirection(from: location))
    }

    private func hit(direction: Direction) {
        let hitArea: SKSpriteNode
        let size: CGFloat = 100
        switch direction {
        case .topLeft:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size * 3/4, height: size * 3/4))
            hitArea.position = CGPoint(x: player.frame.midX - 20, y: player.frame.midY + 20)
        case .top:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size, height: size/2))
            hitArea.position = CGPoint(x: player.frame.midX, y: player.frame.midY + 40)
        case .topRight:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size * 3/4, height: size * 3/4))
            hitArea.position = CGPoint(x: player.frame.midX + 20, y: player.frame.midY + 20)
        case .right:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size/2, height: size))
            hitArea.position = CGPoint(x: player.frame.midX + 40, y: player.frame.midY)
        case .bottomRight:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size * 3/4, height: size * 3/4))
            hitArea.position = CGPoint(x: player.frame.midX + 20, y: player.frame.midY - 20)
        case .bottom:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size, height: size/2))
            hitArea.position = CGPoint(x: player.frame.midX, y: player.frame.midY - 40)
        case .bottomLeft:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size * 3/4, height: size * 3/4))
            hitArea.position = CGPoint(x: player.frame.midX - 20, y: player.frame.midY - 20)
        case .left:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size/2, height: size))
            hitArea.position = CGPoint(x: player.frame.midX - 40, y: player.frame.midY)
        }
        hitArea.zPosition = ZPosition.hitArea.rawValue
        hitArea.name = NodeName.hitArea.rawValue
        hitArea.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent(),
        ]))
        hitArea.physicsBody = SKPhysicsBody(rectangleOf: hitArea.frame.size)
        hitArea.physicsBody?.isDynamic = false
        hitArea.physicsBody?.categoryBitMask = BitMask.hitAreaCategory.rawValue
        hitArea.physicsBody?.contactTestBitMask = BitMask.hitAreaContactTest.rawValue
        addChild(hitArea)

        player.run(SKAction.rotate(toAngle: direction.angle, duration: 0.1, shortestUnitArc: true))
    }

}
