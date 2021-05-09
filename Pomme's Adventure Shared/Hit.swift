import SpriteKit

final class Hit {
    let textures: [SKTexture] = [
        SKTexture(imageNamed: "Broom-1"),
        SKTexture(imageNamed: "Broom-2"),
        SKTexture(imageNamed: "Broom-3"),
        SKTexture(imageNamed: "Broom-4"),
        SKTexture(imageNamed: "Broom-5"),
    ]

    func trigger(in location: CGPoint, player: Player) {
        trigger(to: player.direction(from: location), player: player)
    }

    func trigger(to direction: Direction, player: Player) {
        player.node.run(SKAction.rotate(toAngle: direction.angle + .pi, duration: 1/60, shortestUnitArc: true))

        let area = SKSpriteNode(texture: textures.first)
        player.node.addChild(area)
        area.anchorPoint = CGPoint(x: 0.5, y: 1/6)
        area.zPosition = ZPosition.hitArea.rawValue
        area.name = NodeName.hitArea.rawValue

        area.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: area.size.width, height: area.size.height - player.node.size.height/4),
            center: CGPoint(x: 0, y: area.size.height/2 - player.node.size.height/4)
        )
        area.physicsBody?.isDynamic = false
        area.physicsBody?.categoryBitMask = .hitAreaCategoryBitMask
        area.physicsBody?.collisionBitMask = .hitAreaCollisionBitMask
        area.physicsBody?.contactTestBitMask = .hitAreaContactTestBitMask

        area.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: player.node)]
        area.run(SKAction.sequence([
            SKAction.animate(with: textures, timePerFrame: 1/24),
            SKAction.wait(forDuration: 0.1),
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.removeFromParent(),
        ]))
    }
}
