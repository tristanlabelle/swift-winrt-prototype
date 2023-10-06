import CWinRT
import COM

public struct TrustLevel: Hashable, EnumProjection {
    public typealias CEnum = CWinRT.TrustLevel

    public var value: Int32
    public init(_ value: Int32 = 0) { self.value = value }

    public static let base = Self(0)
    public static let partial = Self(1)
    public static let full = Self(2)
}