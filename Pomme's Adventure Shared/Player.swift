import SpriteKit

extension GameScene {
    var player: SKSpriteNode {
        children.first(where: { $0.name == NodeName.player.rawValue }) as? SKSpriteNode
            ?? errorSpriteNode
    }

    func makePlayer() {
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
    }

    func movePlayer(toLocation location: CGPoint) {
        let factor: CGFloat = 3
        let x: CGFloat = location.x - player.frame.midX
        let y: CGFloat = location.y - player.frame.midY
        player.physicsBody?.velocity = CGVector(dx: x * factor, dy: y * factor)

        player.run(SKAction.rotate(toAngle: atan2(y, x) + .pi/2, duration: 0.1, shortestUnitArc: true))
    }

    func movePlayer(toDirection direction: Direction) {
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

    func playerDirection(from location: CGPoint) -> Direction {
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
}
