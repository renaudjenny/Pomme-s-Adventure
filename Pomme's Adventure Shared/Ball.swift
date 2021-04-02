import SpriteKit

struct Ball {
    static let repeatAddBallActionKey = "ActionRepeatAddBall"

    func addBall(addChild: (SKNode) -> Void, to location: CGPoint, allowedAreas: [CGRect]) {
        let appleType = AppleType.random()
        let ball = SKSpriteNode(texture: appleType.textures.first)
        ball.name = appleType.name
        ball.size = CGSize(width: 20, height: 20)

        let area = allowedAreas.randomElement() ?? .zero

        let position = CGPoint(
            x: CGFloat.random(in: area.minX...area.maxX),
            y: CGFloat.random(in: area.minY...area.maxY)
        )

        let x: CGFloat = location.x - position.x
        let y: CGFloat = location.y - position.y
        let angle: CGFloat = atan2(x, y)
        let dx: CGFloat = sin(angle)
        let dy: CGFloat = cos(angle)
        let impulse = CGVector(
            dx: appleType.impulseFactor * dx,
            dy: appleType.impulseFactor * dy
        )

        ball.position = position
        ball.zPosition = ZPosition.ball.rawValue

        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.categoryBitMask = .ballCategoryBitMask
        ball.physicsBody?.collisionBitMask = .ballCollisionBitMask
        ball.physicsBody?.contactTestBitMask = .ballContactTestBitMask

        addChild(ball)

        ball.alpha = 0
        ball.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 1.4),
            SKAction.applyImpulse(impulse, duration: 1),
        ]))
    }

    func remove(ball: SKNode) {
        guard let appleType = AppleType(node: ball)
        else { return }
        ball.physicsBody?.contactTestBitMask = 0
        ball.physicsBody?.categoryBitMask = 0
        ball.physicsBody?.velocity = .zero
        ball.run(SKAction.sequence([
            SKAction.animate(with: appleType.textures, timePerFrame: 0.1),
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.removeFromParent(),
        ]))
    }
}

extension Ball {
    enum AppleType: CaseIterable {
        case green
        case red

        init?(node: SKNode) {
            guard let ball = Self.allCases.first(where: { $0.name == node.name })
            else { return nil }
            self = ball
        }

        var name: String {
            switch self {
            case .green: return "ball_apple_green"
            case .red: return "ball_apple_red"
            }
        }

        static let names: [String] = Self.allCases.map(\.name)

        static let greenAppleTextures: [SKTexture] = [
            SKTexture(imageNamed: "Green-apple"),
            SKTexture(imageNamed: "Green-apple-sliced-1"),
            SKTexture(imageNamed: "Green-apple-sliced-2"),
            SKTexture(imageNamed: "Green-apple-sliced-3"),
        ]

        static let redAppleTextures: [SKTexture] = [
            SKTexture(imageNamed: "Red-apple"),
            SKTexture(imageNamed: "Red-apple-sliced-1"),
            SKTexture(imageNamed: "Red-apple-sliced-2"),
            SKTexture(imageNamed: "Red-apple-sliced-3"),
        ]

        var textures: [SKTexture] {
            switch self {
            case .green: return Self.greenAppleTextures
            case .red: return Self.redAppleTextures
            }
        }

        static func random() -> Self {
            let randomNumber = Int.random(in: 0...100)
            switch randomNumber {
            case ..<20: return .red
            default: return .green
            }
        }

        var impulseFactor: CGFloat {
            switch self {
            case .green: return 2
            case .red: return 4
            }
        }

        var points: Int {
            switch self {
            case .green: return 100
            case .red: return 200
            }
        }
    }
}

extension GameScene {
    func repeatAddBall() {
        removeAction(forKey: Ball.repeatAddBallActionKey)

        let durationBetweenBalls: TimeInterval = 2.0/TimeInterval(level) + 0.05
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: durationBetweenBalls),
            SKAction.run(addNewBall),
            SKAction.wait(forDuration: durationBetweenBalls),
        ])), withKey: Ball.repeatAddBallActionKey)
    }

    private func addNewBall() {
        ball.addBall(addChild: addChild, to: player.node.frame.center, allowedAreas: allowedBallAppearAreas)
    }

    var allowedBallAppearAreas: [CGRect] {
        let groundFrame = ground.frame.insetBy(dx: 40, dy: 40)
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

}
