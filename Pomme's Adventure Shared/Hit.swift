import SpriteKit

struct Hit {
    private func hitArea(size: CGSize, position: CGPoint) -> SKSpriteNode {
        let area = SKSpriteNode(color: .white, size: size)
        area.position = position
        area.zPosition = ZPosition.hitArea.rawValue
        area.name = NodeName.hitArea.rawValue
        area.physicsBody = SKPhysicsBody(rectangleOf: size)
        area.physicsBody?.isDynamic = false
        area.physicsBody?.categoryBitMask = .hitAreaCategoryBitMask
        area.physicsBody?.collisionBitMask = .hitAreaCollisionBitMask
        area.physicsBody?.contactTestBitMask = .hitAreaContactTestBitMask
        return area
    }

    func area(location: CGPoint, player: Player) -> SKSpriteNode {
        area(direction: player.direction(from: location), player: player)
    }

    func area(direction: Direction, player: Player) -> SKSpriteNode {
        let area: SKSpriteNode
        let size: CGFloat = 100
        let playerFrame = player.node.frame
        switch direction {
        case .topLeft:
            area = hitArea(
                size: CGSize(width: size * 3/4, height: size * 3/4),
                position: CGPoint(x: playerFrame.midX - 20, y: playerFrame.midY + 20)
            )
        case .top:
            area = hitArea(
                size: CGSize(width: size, height: size/2),
                position: CGPoint(x: playerFrame.midX, y: playerFrame.midY + 40)
            )
        case .topRight:
            area = hitArea(
                size: CGSize(width: size * 3/4, height: size * 3/4),
                position: CGPoint(x: playerFrame.midX + 20, y: playerFrame.midY + 20)
            )
        case .right:
            area = hitArea(
                size: CGSize(width: size/2, height: size),
                position: CGPoint(x: playerFrame.midX + 40, y: playerFrame.midY)
            )
        case .bottomRight:
            area = hitArea(
                size: CGSize(width: size * 3/4, height: size * 3/4),
                position: CGPoint(x: playerFrame.midX + 20, y: playerFrame.midY - 20)
            )
        case .bottom:
            area = hitArea(
                size: CGSize(width: size, height: size/2),
                position: CGPoint(x: playerFrame.midX, y: playerFrame.midY - 40)
            )
        case .bottomLeft:
            area = hitArea(
                size: CGSize(width: size * 3/4, height: size * 3/4),
                position: CGPoint(x: playerFrame.midX - 20, y: playerFrame.midY - 20)
            )
        case .left:
            area = hitArea(
                size: CGSize(width: size/2, height: size),
                position: CGPoint(x: playerFrame.midX - 40, y: playerFrame.midY)
            )
        }
        area.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent(),
        ]))

        player.node.run(SKAction.rotate(toAngle: direction.angle, duration: 0.1, shortestUnitArc: true))

        return area
    }
}
