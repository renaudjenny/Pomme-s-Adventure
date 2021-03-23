import SpriteKit

extension GameScene {
    var hitArea: SKSpriteNode? {
        children.first(where: { $0.name == NodeName.hitArea.rawValue }) as? SKSpriteNode
    }

    func hit(location: CGPoint) {
        hit(direction: player.direction(from: location))
    }

    private func hit(direction: Direction) {
        let hitArea: SKSpriteNode
        let size: CGFloat = 100
        switch direction {
        case .topLeft:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size * 3/4, height: size * 3/4))
            hitArea.position = CGPoint(x: player.node.frame.midX - 20, y: player.node.frame.midY + 20)
        case .top:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size, height: size/2))
            hitArea.position = CGPoint(x: player.node.frame.midX, y: player.node.frame.midY + 40)
        case .topRight:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size * 3/4, height: size * 3/4))
            hitArea.position = CGPoint(x: player.node.frame.midX + 20, y: player.node.frame.midY + 20)
        case .right:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size/2, height: size))
            hitArea.position = CGPoint(x: player.node.frame.midX + 40, y: player.node.frame.midY)
        case .bottomRight:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size * 3/4, height: size * 3/4))
            hitArea.position = CGPoint(x: player.node.frame.midX + 20, y: player.node.frame.midY - 20)
        case .bottom:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size, height: size/2))
            hitArea.position = CGPoint(x: player.node.frame.midX, y: player.node.frame.midY - 40)
        case .bottomLeft:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size * 3/4, height: size * 3/4))
            hitArea.position = CGPoint(x: player.node.frame.midX - 20, y: player.node.frame.midY - 20)
        case .left:
            hitArea = SKSpriteNode(color: .white, size: CGSize(width: size/2, height: size))
            hitArea.position = CGPoint(x: player.node.frame.midX - 40, y: player.node.frame.midY)
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
        hitArea.physicsBody?.categoryBitMask = .hitAreaCategoryBitMask
        hitArea.physicsBody?.collisionBitMask = .hitAreaCollisionBitMask
        hitArea.physicsBody?.contactTestBitMask = .hitAreaContactTestBitMask
        addChild(hitArea)

        physicsContact?.hitAreaNode = hitArea

        // TODO: Hit should be triggered by the player at the end of the day...
        player.node.run(SKAction.rotate(toAngle: direction.angle, duration: 0.1, shortestUnitArc: true))
    }

}
