import SpriteKit

class GameScene: SKScene {
    var physicsContact: PhysicsContact?
    let player = Player()
    let ball = Ball()
    let hit = Hit()

    let errorSpriteNode = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
    var ground: SKSpriteNode {
        children.first(where: { $0.name == NodeName.ground.rawValue }) as? SKSpriteNode
            ?? errorSpriteNode
    }
    var center: CGPoint {
        CGPoint(x: ground.frame.midX, y: ground.frame.midY)
    }
    var scoreLabel: SKLabelNode {
        children.first(where: { $0.name == NodeName.score.rawValue }) as? SKLabelNode
            ?? SKLabelNode(text: "ERROR")
    }
    var levelLabel: SKLabelNode {
        children.first(where: { $0.name == NodeName.level.rawValue }) as? SKLabelNode
            ?? SKLabelNode(text: "ERROR")
    }

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            setLevelPerScore()
        }
    }
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
            repeatAddBall()
        }
    }
    var isGameOver = false

    var allowedBallAppearAreas: [CGRect] {
        let groundFrame = ground.frame.insetBy(dx: 30, dy: 30)
        let playerFrame = player.node.frame.insetBy(dx: -50, dy: -50)

        let (left, _) = groundFrame.divided(atDistance: playerFrame.minX - groundFrame.minX, from: .minXEdge)
        let (right, _) = groundFrame.divided(atDistance: groundFrame.maxX - playerFrame.maxX, from: .maxXEdge)
        let (bottom, _) = groundFrame.divided(atDistance: playerFrame.minY - groundFrame.minY, from: .minYEdge)
        let (top, _) = groundFrame.divided(atDistance: groundFrame.maxY - playerFrame.maxY, from: .maxYEdge)

        // Debug code for the safe area
//        [(left, SKColor.blue), (right, SKColor.green), (bottom, SKColor.yellow), (top, SKColor.red)].forEach { rect, color in
//            let test = SKSpriteNode(color: color.withAlphaComponent(2/3), size: rect.size)
//            test.anchorPoint = .zero
//            test.position = rect.origin
//            self.addChild(test)
//            test.run(SKAction.sequence([SKAction.fadeOut(withDuration: 6), SKAction.removeFromParent()]))
//        }

        return [left, right, bottom, top]
            .filter { !$0.isEmpty }
    }

    class func newGameScene() -> GameScene {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        physicsContact = PhysicsContact(
            collisionBetweenMovePlayerAreaAndPlayer: player.stopMoving,
            borderNode: self,
            groundNode: ground,
            playerNode: player.node,
            ballHit: removeBall,
            playerTouched: playerTouched
        )

        let ground = SKSpriteNode(color: SKColor.white.withAlphaComponent(0.1), size: frame.insetBy(dx: 10, dy: 60).size)
        ground.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        ground.zPosition = ZPosition.ground.rawValue
        ground.name = NodeName.ground.rawValue
        addChild(ground)

        addChild(player.node)
        player.node.position = center

        let scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: frame.minX + 20, y: frame.minY + 20)
        scoreLabel.fontSize = 40
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.name = NodeName.score.rawValue
        addChild(scoreLabel)

        let levelLabel = SKLabelNode(text: "Level: 1")
        levelLabel.position = CGPoint(x: frame.minX + 20, y: scoreLabel.frame.maxY + 20)
        levelLabel.fontSize = 30
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.name = NodeName.level.rawValue
        addChild(levelLabel)

        self.name = NodeName.border.rawValue
        physicsBody = SKPhysicsBody(edgeLoopFrom: ground.frame)
        physicsBody?.categoryBitMask = BitMask.borderCategory.rawValue

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = physicsContact

        run(SKAction.sequence([
            SKAction.wait(forDuration: 2),
            SKAction.run(repeatAddBall),
        ]))
    }

    private func setLevelPerScore() {
        switch score {
        case ..<500: level = 1
        case 500..<1_000: level = 2
        case 1_000..<2_000: level = 3
        case 2_000..<3_000: level = 4
        case 3_000..<5_000: level = 5
        case 5_000..<8_000: level = 6
        case 13_000..<21_000: level = 7
        case 21_000..<34_000: level = 8
        case 34_000..<55_000: level = 9
        case 55_000..<89_000: level = 10
        case 89_000..<144_000: level = 11
        case 144_000..<233_000: level = 12
        case 233_000..<377_000: level = 13
        case 377_000..<610_000: level = 14
        case 610_000..<987_000: level = 15
        case 987_000...: level = 16
        default: break
        }
    }
}
