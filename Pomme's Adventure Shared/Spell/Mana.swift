import SpriteKit

struct Mana {
    static let max = 500
    private static let barHeight: CGFloat = 10
    static let repeatRegenerateManaActionKey = "RepeatRegenerateManaActionKey"

    let node = SKNode()
    private let bar = SKShapeNode(rectOf: CGSize(width: 0, height: Mana.barHeight), cornerRadius: 4)
    private var width: CGFloat = 0

    var value = 0 {
        didSet {
            if value >= Mana.max {
                value = Mana.max
                return
            }

            let newWidth = width * CGFloat(value)/CGFloat(Mana.max)
            let height = Mana.barHeight
            let origin = CGPoint(x: 0, y: -height/2)
            let rect = CGRect(origin: origin, size: CGSize(width: newWidth , height: height))
            bar.path = CGPath(roundedRect: rect, cornerWidth: 4, cornerHeight: 4, transform: nil)
        }
    }

    mutating func configure(width: CGFloat) {
        self.width = width
        let background = SKShapeNode(rectOf: CGSize(width: width, height: Mana.barHeight), cornerRadius: 4)
        background.fillColor = .black
        bar.fillColor = .orange
        bar.position = CGPoint(x: -width/2, y: background.frame.midY)
        node.addChild(background)
        node.addChild(bar)
    }
}

extension GameScene {
    func startRegeneratingMana() {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run { [weak self] in
                    self?.spell.mana.value += 1
                },
                SKAction.wait(forDuration: 1)
            ])
        ), withKey: Mana.repeatRegenerateManaActionKey)
    }
}
