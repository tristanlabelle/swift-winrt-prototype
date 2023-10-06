public enum NullableProjection<Inner: ABIProjection>: ABIProjection {
    public typealias SwiftType = Inner.SwiftType?
    public typealias ABIType = Inner.ABIType?

    public static func toSwift(copying value: Inner.ABIType?) -> Inner.SwiftType? {
        guard let value else { return nil }
        return Inner.toSwift(copying: value)
    }

    public static func toSwift(consuming value: Inner.ABIType?) -> Inner.SwiftType? {
        guard let value else { return nil }
        return Inner.toSwift(consuming: value)
    }

    public static func toABI(_ value: Inner.SwiftType?) throws -> Inner.ABIType? {
        guard let value else { return nil }
        return try Inner.toABI(value)
    }

    public static func release(_ value: Inner.ABIType?) {
        if let value { Inner.release(value) }
    }
}