import COM
import CWinRT

public struct EventRegistrationToken {
    public var value: Int64
    public init(_ value: Int64) { self.value = value }
}

extension EventRegistrationToken: ABIInertProjection {
    public typealias SwiftValue = Self
    public typealias ABIValue = CWinRT.EventRegistrationToken
    public static func toSwift(_ value: ABIValue) -> SwiftValue { SwiftValue(value.value) }
    public static func toABI(_ value: SwiftValue) throws -> ABIValue { ABIValue(value: value.value) }
}