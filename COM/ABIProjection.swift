/// A type that manages the projection between the Swift and ABI representation of a type of values.
public protocol ABIProjection {
    /// The type for the Swift representation of values
    associatedtype SwiftType

    // The type for the ABI representation of values
    associatedtype ABIType

    /// Converts a value from its ABI to its Swift representation
    /// without releasing the original value.
    static func toSwift(copying value: ABIType) -> SwiftType

    /// Converts a value from its ABI to its Swift representation,
    /// releasing the original value.
    static func toSwift(consuming value: ABIType) -> SwiftType

    /// Converts a value from its Swift to its ABI representation.
    /// The resulting value should be released as its creation might have allocated resources.
    static func toABI(_ value: SwiftType) throws -> ABIType

    /// Releases up any allocated resources associated with the ABI representation of a value.
    static func release(_ value: ABIType)
}

extension ABIProjection {
    public static func toSwift(consuming value: ABIType?) -> SwiftType? {
        guard let value else { return nil }
        return Optional(toSwift(consuming: value))
    }

    public static func toSwift(copying value: ABIType?) -> SwiftType? {
        guard let value else { return nil }
        return Optional(toSwift(copying: value))
    }

    public static func release(_ value: ABIType?) {
        if let value { release(value) }
    }

    public static func withABI<Result>(_ value: SwiftType, _ closure: (ABIType) throws -> Result) throws -> Result {
        let abiValue = try toABI(value)
        defer { release(abiValue) }
        return try closure(abiValue)
    }
}

/// A type that projects values between Swift and ABI representations,
/// where the ABI representation requires no resource allocation.
/// For conformance convenience.
public protocol ABIInertProjection: ABIProjection {
    static func toSwift(_ value: ABIType) -> SwiftType
}

extension ABIInertProjection {
    public static func toSwift(consuming value: ABIType) -> SwiftType { toSwift(value) }
    public static func toSwift(copying value: ABIType) -> SwiftType { toSwift(value) }
    public static func release(_ value: ABIType) {}
}

public enum ABIProjectionError: Error {
    case unsupported(Any.Type)
}