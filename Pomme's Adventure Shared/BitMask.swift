import SpriteKit

struct BitMask: OptionSet {
    let rawValue: UInt32

    static let borderCategory = BitMask(rawValue: 1 << 1)
    static let playerCategory = BitMask(rawValue: 1 << 2)
    static let ballCategory = BitMask(rawValue: 1 << 3)
    static let hitAreaCategory = BitMask(rawValue: 1 << 4)
    static let movePlayerAreaCategory = BitMask(rawValue: 1 << 5)

    static let playerCollision: BitMask = [.borderCategory]
    static let ballCollision: BitMask = [.borderCategory, .playerCategory]
    static let hitAreaCollision: BitMask = []

    static let playerContactTest: BitMask = [.ballCategory, .movePlayerAreaCategory]
    static let ballContactTest: BitMask = [.playerCategory, .hitAreaCategory]
    static let hitAreaContactTest: BitMask = [.ballCategory]
}

extension UInt32 {
    static let borderCategoryBitMask: Self = BitMask.borderCategory.rawValue
    static let playerCategoryBitMask: Self = BitMask.playerCategory.rawValue
    static let ballCategoryBitMask: Self = BitMask.ballCategory.rawValue
    static let hitAreaCategoryBitMask: Self = BitMask.hitAreaCategory.rawValue
    static let movePlayerAreaCategoryBitMask: Self = BitMask.movePlayerAreaCategory.rawValue

    static let playerCollisionBitMask: Self = BitMask.playerCollision.rawValue
    static let ballCollisionBitMask: Self = BitMask.ballCollision.rawValue
    static let hitAreaCollisionBitMask: Self = BitMask.hitAreaCollision.rawValue

    static let playerContactTestBitMask: Self = BitMask.playerContactTest.rawValue
    static let ballContactTestBitMask: Self = BitMask.ballContactTest.rawValue
    static let hitAreaContactTestBitMask: Self = BitMask.hitAreaContactTest.rawValue
}
