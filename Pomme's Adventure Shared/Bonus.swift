import SpriteKit

struct Bonus {
    static let repeatAddBonusActionKey = "ActionRepeatAddBonus"

    func addBonus(addChild: (SKNode) -> Void, area: CGRect) {
        let size = CGSize(width: 50, height: 85)
        guard let gemType = GemType.allCases.randomElement()
        else { return }

        let node = SKSpriteNode(texture: gemType.textures.first, size: size)
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

        node.run(SKAction.repeatForever(SKAction.animate(with: gemType.textures, timePerFrame: 0.2)))

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
                SKAction.wait(forDuration: 0.2),
                SKAction.fadeIn(withDuration: 0.1),
                SKAction.wait(forDuration: 0.2),
            ]),
            count: 6),
            SKAction.removeFromParent(),
        ]))
    }
}

extension Bonus {
    enum GemType: CaseIterable {
        case blue
        case purple

        static let blueGemTextures: [SKTexture] = [
            SKTexture(imageNamed: "Blue-gem-1"),
            SKTexture(imageNamed: "Blue-gem-2"),
        ]
        static let purpleGemTextures: [SKTexture] = [
            SKTexture(imageNamed: "Purple-gem-1"),
            SKTexture(imageNamed: "Purple-gem-2"),
        ]

        var textures: [SKTexture] {
            switch self {
            case .blue: return Self.blueGemTextures
            case .purple: return Self.purpleGemTextures
            }
        }
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
