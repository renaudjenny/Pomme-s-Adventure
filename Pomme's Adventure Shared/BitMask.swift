import SpriteKit

struct BitMask: OptionSet {
    let rawValue: UInt32

    static let borderCategory = BitMask(rawValue: 1 << 0)
    static let playerCategory = BitMask(rawValue: 1 << 1)
    static let ballCategory = BitMask(rawValue: 1 << 2)
    static let hitAreaCategory = BitMask(rawValue: 1 << 3)
    static let movePlayerAreaCategory = BitMask(rawValue: 1 << 4)

    static let playerCollision: BitMask = [.ballCategory, .borderCategory]
    static let ballCollision: BitMask = [.ballCategory, .playerCategory, .hitAreaCategory, .borderCategory]
    static let hitAreaCollision: BitMask = [.ballCategory]

    static let playerContactTest: BitMask = [.ballCategory, .movePlayerAreaCategory]
    static let ballContactTest: BitMask = [.playerCategory, .hitAreaCategory, .borderCategory]
    static let hitAreaContactTest: BitMask = [.ballCategory]
    static let movePlayerAreaContactTest: BitMask = [.playerCategory]
}
