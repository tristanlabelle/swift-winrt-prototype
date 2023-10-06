/// A type that manages the projection between the Swift and ABI representation of a type of values.
public protocol ABIProjection {
    associatedtype SwiftType
    associatedtype ABIType

    /// Converts a value from its ABI to its Swift representation.
    static func toSwift(_ value: ABIType) -> SwiftType

    /// Converts a value from its Swift to its ABI representation.
    /// The resulting value should be cleaned up as its creation might have allocated resources.
    static func toABI(_ value: SwiftType) throws -> ABIType

    /// Cleans up any allocated resources associated with the ABI representation of a value.
    static func cleanup(_ value: ABIType)
}

extension ABIProjection {
    public static func toSwift(_ value: ABIType?) -> SwiftType? {
        guard let value else { return nil }
        return Optional(toSwift(value))
    }

    public static func toSwiftAndCleanup(_ value: ABIType) -> SwiftType {
        defer { cleanup(value) }
        return toSwift(value)
    }

    public static func toSwiftAndCleanup(_ value: ABIType?) -> SwiftType? {
        guard let value else { return nil }
        return Optional(toSwiftAndCleanup(value))
    }

    public static func cleanup(_ value: ABIType?) {
        if let value { cleanup(value) }
    }

    public static func withABI<Result>(_ value: SwiftType, _ closure: (ABIType) throws -> Result) throws -> Result {
        let abiValue = try toABI(value)
        defer { cleanup(abiValue) }
        return try closure(abiValue)
    }
}

public enum ABIProjectionError: Error {
    case unsupported(Any.Type)
}