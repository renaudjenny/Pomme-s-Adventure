import SpriteKit

struct BitMask: OptionSet {
    let rawValue: UInt32

    static let playerCategory = BitMask(rawValue: 1 << 1)
    static let ballCategory = BitMask(rawValue: 1 << 2)
    static let hitAreaCategory = BitMask(rawValue: 1 << 3)

    static let playerContactTest: BitMask = [.ballCategory]
    static let ballContactTest: BitMask = [.playerCategory, .hitAreaCategory]
    static let hitAreaContactTest: BitMask = [.ballCategory]
}
