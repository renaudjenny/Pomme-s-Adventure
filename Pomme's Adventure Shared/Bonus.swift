import SpriteKit

struct Bonus {
    static let repeatAddBonusActionKey = "ActionRepeatAddBonus"

    func addBonus(addChild: (SKNode) -> Void, area: CGRect) {
        let size = CGSize(width: 40, height: 50)
        let node = SKSpriteNode(color: .yellow, size: size)
        node.name = NodeName.bonus.rawValue
        let area = area.insetBy(dx: size.width/2, dy: size.height/2)

        let position = CGPoint(
            x: CGFloat.random(in: area.minX...area.maxX),
            y: CGFloat.random(in: area.minY...area.maxY)
        )

        node.position = position
        node.zPosition = ZPosition.bonus.rawValue

        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = .bonusCategoryBitMask
        node.physicsBody?.collisionBitMask = .bonusCollisionBitMask
        node.physicsBody?.contactTestBitMask = .bonusContactTestBitMask

        addChild(node)

        node.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 1),
            SKAction.wait(forDuration: 5),
            SKAction.run { remove(bonus: node) },
        ]))
    }

    func remove(bonus: SKNode) {
        bonus.run(SKAction.sequence([
            SKAction.repeat(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.1),
                SKAction.wait(forDuration: 0.5),
                SKAction.fadeIn(withDuration: 0.1),
                SKAction.wait(forDuration: 0.5),
            ]),
            count: 5),
            SKAction.removeFromParent(),
        ]))
    }
}

extension GameScene {
    func repeatAddBonuses() {
        removeAction(forKey: Bonus.repeatAddBonusActionKey)

        let durationBetweenBonuses: TimeInterval = 10
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: durationBetweenBonuses),
            SKAction.run(addNewBonus),
        ])), withKey: Bonus.repeatAddBonusActionKey)
    }

    private func addNewBonus() {
        bonus.addBonus(addChild: addChild, area: ground.frame)
    }
}
