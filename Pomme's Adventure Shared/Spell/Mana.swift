import SpriteKit

struct Mana {
    let node = SKNode()
    let crop = SKCropNode()

    func configure(width: CGFloat) {
        let background = SKShapeNode(rectOf: CGSize(width: width, height: 10), cornerRadius: 4)
        background.fillColor = .black
        let progress = SKShapeNode(rectOf: CGSize(width: width, height: 10), cornerRadius: 4)
        progress.fillColor = .orange
        crop.addChild(progress)
        node.addChild(background)
        node.addChild(crop)
    }
}
