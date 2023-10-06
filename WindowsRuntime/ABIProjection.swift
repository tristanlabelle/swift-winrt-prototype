/// A type that manages the projection between the Swift and ABI representation of a type of values.
public protocol ABIProjection {
    associatedtype SwiftType
    associatedtype ABIType

    /// Gets the Swift representation of the value.
    var swiftValue: SwiftType { get }

    /// Gets the ABI representation of the value.
    var abiValue: ABIType { get }

    /// Creates the projection of a given ABI value.
    init(_ value: ABIType)

    /// Converts a value from its Swift to its ABI representation.
    /// The resulting value should be cleaned up as its creation might have allocated resources.
    static func toABI(_ value: SwiftType) throws -> ABIType

    /// Cleans up any allocated resources associated with the ABI representation of a value.
    static func cleanup(_ value: ABIType)
}

extension ABIProjection {
    public init(cleaningUp value: ABIType) {
        self.init(value)
        Self.cleanup(value)
    }

    public static func toSwift(_ value: ABIType) -> SwiftType {
        Self(value).swiftValue
    }

    public static func toSwift(_ value: ABIType?) -> SwiftType? {
        guard let value else { return nil }
        return Self(value).swiftValue
    }

    public static func toSwiftAndCleanup(_ value: ABIType) -> SwiftType {
        Self(cleaningUp: value).swiftValue
    }

    public static func toSwiftAndCleanup(_ value: ABIType?) -> SwiftType? {
        guard let value else { return nil }
        return Self(cleaningUp: value).swiftValue
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