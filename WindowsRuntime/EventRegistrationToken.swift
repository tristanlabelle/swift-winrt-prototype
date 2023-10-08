import COM
import CWinRT

public struct EventRegistrationToken {
    public var value: Int64
    public init(_ value: Int64 = 0) { self.value = value }

    public static let none = Self(0)
}

extension EventRegistrationToken: ABIInertProjection {
    public typealias SwiftValue = Self
    public typealias ABIValue = CWinRT.EventRegistrationToken
    public static func toSwift(_ value: ABIValue) -> SwiftValue { SwiftValue(value.value) }
    public static func toABI(_ value: SwiftValue) throws -> ABIValue { ABIValue(value: value.value) }
}