import SpriteKit

final class Hit {
    let textures: [SKTexture] = [
        SKTexture(imageNamed: "Broom-1"),
        SKTexture(imageNamed: "Broom-2"),
        SKTexture(imageNamed: "Broom-3"),
        SKTexture(imageNamed: "Broom-4"),
        SKTexture(imageNamed: "Broom-5"),
    ]

    private func hitArea(playerHeight: CGFloat) -> SKSpriteNode {
        let size = CGSize(width: 200, height: 125)
        let area = SKSpriteNode(texture: textures.first, size: size)
        area.anchorPoint = CGPoint(x: 0.5, y: 1/6)
        area.zPosition = ZPosition.hitArea.rawValue
        area.name = NodeName.hitArea.rawValue
        area.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: size.width, height: size.height - playerHeight/2),
            center: CGPoint(x: 0, y: playerHeight)
        )
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
        let area = hitArea(playerHeight: player.node.frame.height)
        area.position = player.node.position
        area.zRotation = direction.angle + .pi
        area.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: player.node)]
        area.run(SKAction.sequence([
            SKAction.animate(with: textures, timePerFrame: 1/24),
            SKAction.wait(forDuration: 0.1),
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.removeFromParent(),
        ]))

        player.node.run(SKAction.rotate(toAngle: direction.angle, duration: 1/60, shortestUnitArc: true))

        return area
    }
}
