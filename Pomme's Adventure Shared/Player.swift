import SpriteKit

struct Player {
    let node: SKSpriteNode
    let movementTextures: [SKTexture] = [
        SKTexture(imageNamed: "Pomme-move"),
        SKTexture(imageNamed: "Pomme-move-2")
    ]

    var safeArea: CGRect {
        CGRect(
            x: node.frame.minX - node.size.width * 2,
            y: node.frame.minY - node.size.height * 2,
            width: node.size.width * 5,
            height: node.size.height * 5
        )
    }

    init() {
        node = SKSpriteNode(imageNamed: "Pomme-static")

        node.size = CGSize(width: 50, height: 50)
        node.zPosition = ZPosition.player.rawValue
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.width/2 * 0.9)
        node.physicsBody?.categoryBitMask = BitMask.playerCategory.rawValue
        node.physicsBody?.contactTestBitMask = BitMask.playerContactTest.rawValue
        node.physicsBody?.categoryBitMask = BitMask.playerCategory.rawValue
        node.name = NodeName.player.rawValue
    }

    func move(toLocation location: CGPoint) {
        let x: CGFloat = location.x - node.frame.midX
        let y: CGFloat = location.y - node.frame.midY

        node.run(SKAction.group([
            SKAction.rotate(toAngle: atan2(y, x) + .pi/2, duration: 0.1, shortestUnitArc: true),
            SKAction.move(to: location, duration: 0.2),
            SKAction.animate(with: movementTextures, timePerFrame: 0.2)
        ]))
    }

    func move(toDirection direction: Direction) {
        let factor: CGFloat = 1
        switch direction {
        case .topLeft:
            node.physicsBody?.velocity = CGVector(dx: -1 * factor, dy: 1 * factor)
        case .top:
            node.physicsBody?.velocity = CGVector(dx: 0 * factor, dy: 1 * factor)
        case .topRight:
            node.physicsBody?.velocity = CGVector(dx: 1 * factor, dy: 1 * factor)
        case .right:
            node.physicsBody?.velocity = CGVector(dx: 1 * factor, dy: 0 * factor)
        case .bottomRight:
            node.physicsBody?.velocity = CGVector(dx: 1 * factor, dy: -1 * factor)
        case .bottom:
            node.physicsBody?.velocity = CGVector(dx: 0 * factor, dy: -1 * factor)
        case .bottomLeft:
            node.physicsBody?.velocity = CGVector(dx: -1 * factor, dy: -1 * factor)
        case .left:
            node.physicsBody?.velocity = CGVector(dx: -1 * factor, dy: 0 * factor)
        }
    }

    func stopMoving() {
        node.physicsBody?.velocity = .zero
        node.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.setTexture(SKTexture(imageNamed: "Pomme-static")),
        ]))
    }

    func fall(resurrectionPosition: CGPoint) {
        node.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.6),
            SKAction.move(to: resurrectionPosition, duration: 0.1),
            SKAction.fadeIn(withDuration: 0.6)
        ]))
    }

    func direction(from location: CGPoint) -> Direction {
        let x = node.frame.midX - location.x
        let y = node.frame.midY - location.y
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