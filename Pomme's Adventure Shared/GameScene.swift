import SpriteKit

class GameScene: SKScene {
    private var physicsContact: PhysicsContact?
    private let errorSpriteNode = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
    var player: SKSpriteNode {
        children.first(where: { $0.name == NodeName.player.rawValue }) as? SKSpriteNode
            ?? errorSpriteNode
    }
    var ground: SKSpriteNode {
        children.first(where: { $0.name == NodeName.ground.rawValue }) as? SKSpriteNode
            ?? errorSpriteNode
    }
    var scoreLabel: SKLabelNode {
        children.first(where: { $0.name == NodeName.score.rawValue }) as? SKLabelNode
            ?? SKLabelNode(text: "ERROR")
    }
    var levelLabel: SKLabelNode {
        children.first(where: { $0.name == NodeName.level.rawValue }) as? SKLabelNode
            ?? SKLabelNode(text: "ERROR")
    }
    var hitArea: SKSpriteNode? {
        children.first(where: { $0.name == NodeName.hitArea.rawValue }) as? SKSpriteNode
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

    class func newGameScene() -> GameScene {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        physicsContact = PhysicsContact(collisionBetweenBall: collisionBetween)

        let ground = SKSpriteNode(color: SKColor.white.withAlphaComponent(0.1), size: frame.insetBy(dx: 10, dy: 60).size)
        ground.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        ground.zPosition = ZPosition.ground.rawValue
        ground.name = NodeName.ground.rawValue
        addChild(ground)

        let player = SKSpriteNode(imageNamed: "Pomme-static")
        player.size = CGSize(width: 50, height: 50)
        player.position = CGPoint(x: ground.frame.midX, y: ground.frame.midY)
        player.zPosition = ZPosition.player.rawValue
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width/2 * 0.9)
        player.physicsBody?.categoryBitMask = BitMask.playerCategory.rawValue
        player.physicsBody?.collisionBitMask = BitMask.playerCollision.rawValue
        player.physicsBody?.contactTestBitMask = BitMask.playerContactTest.rawValue
        player.physicsBody?.mass = 80
        player.physicsBody?.linearDamping = 1
        player.name = NodeName.player.rawValue
        addChild(player)

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

        physicsBody = SKPhysicsBody(edgeLoopFrom: ground.frame)
        player.physicsBody?.categoryBitMask = BitMask.borderCategory.rawValue

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = physicsContact

        //        view.showsPhysics = true

        run(SKAction.sequence([
            SKAction.wait(forDuration: 2),
            SKAction.run(repeatAddBall),
        ]))
    }

    override func update(_ currentTime: TimeInterval) {
        #if os(iOS) || os(tvOS)
        if let movePlayerAreaFrame = movePlayerArea?.frame,
           player.frame.intersects(movePlayerAreaFrame) {
            stopMovePlayer()
        }
        #endif
    }

    func movePlayer(toLocation location: CGPoint) {
        let factor: CGFloat = 3
        let x: CGFloat = location.x - player.frame.midX
        let y: CGFloat = location.y - player.frame.midY
        player.physicsBody?.velocity = CGVector(dx: x * factor, dy: y * factor)

        player.run(SKAction.rotate(toAngle: atan2(y, x) + .pi/2, duration: 0.2, shortestUnitArc: true))
    }

    private func movePlayer(toDirection direction: Direction) {
        let factor: CGFloat = 300
        switch direction {
        case .topLeft:
            player.physicsBody?.velocity = CGVector(dx: -1 * factor, dy: 1 * factor)
        case .top:
            player.physicsBody?.velocity = CGVector(dx: 0 * factor, dy: 1 * factor)
        case .topRight:
            player.physicsBody?.velocity = CGVector(dx: 1 * factor, dy: 1 * factor)
        case .right:
            player.physicsBody?.velocity = CGVector(dx: 1 * factor, dy: 0 * factor)
        case .bottomRight:
            player.physicsBody?.velocity = CGVector(dx: 1 * factor, dy: -1 * factor)
        case .bottom:
            player.physicsBody?.velocity = CGVector(dx: 0 * factor, dy: -1 * factor)
        case .bottomLeft:
            player.physicsBody?.velocity = CGVector(dx: -1 * factor, dy: -1 * factor)
        case .left:
            player.physicsBody?.velocity = CGVector(dx: -1 * factor, dy: 0 * factor)
        }
    }

    func stopMovePlayer() {
        player.physicsBody?.velocity = .zero
        player.removeAction(forKey: "MoveAnimationAction")
        player.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.setTexture(SKTexture(imageNamed: "Pomme-static")),
        ]))
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
        hitArea.physicsBody?.collisionBitMask = BitMask.hitAreaCollision.rawValue
        hitArea.physicsBody?.contactTestBitMask = BitMask.hitAreaContactTest.rawValue
        addChild(hitArea)

        player.run(SKAction.rotate(toAngle: direction.angle, duration: 0.1, shortestUnitArc: true))
    }

    private func playerDirection(from location: CGPoint) -> Direction {
        let x = player.frame.midX - location.x
        let y = player.frame.midY - location.y
        let radian = atan2(x, y)

        switch radian {
        case -.pi/6 ... .pi/6: return .bottom
        case .pi/6 ... .pi/3: return .bottomLeft
        case .pi/3 ... 2 * .pi/3: return .left
        case 2 * .pi/3 ... 5 * .pi/6: return .topLeft
        case 5 * .pi/6 ... .pi,
             -.pi ..< -5 * .pi/6:
            return .top
        case -5 * .pi/6 ... -2 * .pi/3: return .topRight
        case -2 * .pi/3 ... -.pi/3: return .right
        case -.pi/3 ... -.pi/6: return .bottomRight
        default:
            // This should not happen!
            return .top
        }
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
