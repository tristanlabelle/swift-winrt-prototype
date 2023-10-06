import CWinRT

// A type which converts between a COM interface and a corresponding Swift value.
public protocol COMProjection: ABIProjection, IUnknownProtocol where ABIType == CPointer {
    associatedtype SwiftType
    associatedtype CStruct
    associatedtype CVTableStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>
    typealias CVTablePointer = UnsafePointer<CVTableStruct>

    var swiftValue: SwiftType { get }
    var _pointer: CPointer { get }

    init(transferringRef pointer: CPointer)

    static var iid: IID { get }
}

extension COMProjection {
    public var _unknown: UnsafeMutablePointer<CWinRT.IUnknown> {
        _pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0 }
    }

    public var _vtable: CVTableStruct {
        _read {
            let unknownVTable = UnsafePointer(_unknown.pointee.lpVtbl!)
            let pointer = unknownVTable.withMemoryRebound(to: CVTableStruct.self, capacity: 1) { $0 }
            yield pointer.pointee
        }
    }

    public init(_ pointer: CPointer) {
        self.init(transferringRef: pointer)
        _unknown.addRef()
    }

    public static func toSwiftAndCleanup(_ value: ABIType) -> SwiftType {
        Self(transferringRef: value).swiftValue
    }

    public static func toSwift(_ value: ABIType) -> SwiftType {
        Self(value).swiftValue
    }

    public static func toABI(_ value: SwiftType) throws -> ABIType {
        switch value {
            case let object as COMObjectBase<Self>:
                object._unknown.addRef()
                return object._pointer

            case let unknown as IUnknown:
                return try unknown._queryInterfacePointer(Self.self)

            default:
                throw ABIProjectionError.unsupported(SwiftType.self)
        }
    }

    public static func cleanup(_ pointer: CPointer) {
        pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) {
            _ = $0.release()
        }
    }
}

// Protocol for strongly-typed two-way COM interface projections into and from Swift.
public protocol COMTwoWayProjection: COMProjection {
    static var _vtable: CVTablePointer { get }
}
