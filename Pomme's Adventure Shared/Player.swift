import SpriteKit

struct Player {
    static let repeatMovementAnimationActionKey = "PlayerRepeatAnimationMovementActionKey"

    let node: SKSpriteNode
    let movementTextures: [SKTexture] = [
        SKTexture(imageNamed: "Pomme-Hair-1"),
        SKTexture(imageNamed: "Pomme-Hair-2"),
        SKTexture(imageNamed: "Pomme-Hair-3"),
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
        node = SKSpriteNode(imageNamed: "Pomme")
        node.anchorPoint = CGPoint(x: 0.5, y: 0)
        node.zPosition = ZPosition.player.rawValue
        node.physicsBody = SKPhysicsBody(
            circleOfRadius: node.frame.width/2 * 0.9,
            center: CGPoint(x: 0, y: node.size.height/2)
        )
        node.physicsBody?.categoryBitMask = .playerCategoryBitMask
        node.physicsBody?.contactTestBitMask = .playerContactTestBitMask
        node.physicsBody?.collisionBitMask = .playerCollisionBitMask
        node.name = NodeName.player.rawValue
    }

    func move(toLocation location: CGPoint) {
        let x: CGFloat = location.x - node.frame.midX
        let y: CGFloat = location.y - node.frame.midY
        let factor: CGFloat = 2

        if node.physicsBody?.velocity == .zero {
            node.run(SKAction.repeatForever(
                SKAction.animate(with: movementTextures, timePerFrame: 1/12, resize: true, restore: false)
            ), withKey: Player.repeatMovementAnimationActionKey)
        }

        node.physicsBody?.velocity = CGVector(dx: x * factor, dy: y * factor)
        node.physicsBody?.angularVelocity = 0

        node.run(SKAction.rotate(toAngle: atan2(y, x) + .pi/2, duration: 0.1, shortestUnitArc: true))
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
        node.removeAction(forKey: Player.repeatMovementAnimationActionKey)
        node.run(SKAction.setTexture(SKTexture(imageNamed: "Pomme"), resize: true))
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
