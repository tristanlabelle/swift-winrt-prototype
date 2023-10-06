import CWinRT

// A type which converts between a COM interface and a corresponding Swift value.
public protocol COMProjection: ABIProjection, IUnknownProtocol where ABIType == CPointer {
    associatedtype CStruct
    associatedtype CVTableStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>
    typealias CVTablePointer = UnsafePointer<CVTableStruct>

    var swiftValue: SwiftType { get }
    var pointer: CPointer { get }

    init(transferringRef pointer: CPointer)

    static var iid: IID { get }
}

extension COMProjection {
    public var unknownPointer: IUnknownPointer {
        IUnknownPointer.cast(pointer)
    }

    public var vtable: CVTableStruct {
        _read {
            let unknownVTable = UnsafePointer(unknownPointer.pointee.lpVtbl!)
            let pointer = unknownVTable.withMemoryRebound(to: CVTableStruct.self, capacity: 1) { $0 }
            yield pointer.pointee
        }
    }

    public init(_ pointer: CPointer) {
        self.init(transferringRef: pointer)
        unknownPointer.addRef()
    }

    public static func toSwift(copying value: ABIType) -> SwiftType {
        Self(value).swiftValue
    }

    public static func toSwift(consuming value: ABIType) -> SwiftType {
        Self(transferringRef: value).swiftValue
    }

    public static func toABI(_ value: SwiftType) throws -> ABIType {
        switch value {
            case let object as COMProjectionObject<Self>:
                object.unknownPointer.addRef()
                return object.pointer

            case let unknown as IUnknown:
                return try unknown._queryInterfacePointer(Self.self)

            default:
                throw ABIProjectionError.unsupported(SwiftType.self)
        }
    }

    public static func release(_ pointer: CPointer) {
        IUnknownPointer.release(pointer)
    }
}

// Protocol for strongly-typed two-way COM interface projections into and from Swift.
public protocol COMTwoWayProjection: COMProjection {
    static var vtable: CVTablePointer { get }
}
