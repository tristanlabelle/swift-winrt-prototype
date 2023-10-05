import CWinRT

// Protocol for strongly-typed COM interface projections into Swift.
public protocol COMProjection: IUnknownProtocol {
    associatedtype SwiftType
    associatedtype CStruct
    associatedtype CVTableStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>
    typealias CVTablePointer = UnsafePointer<CVTableStruct>

    var _pointer: CPointer { get }
    var _swiftValue: SwiftType { get }

    init(_transferringRef pointer: CPointer)

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

    public init(_referencing pointer: CPointer) {
        self.init(_transferringRef: pointer)
        _unknown.addRef()
    }

    public static func get(transferringRef pointer: CPointer) -> Self {
        // TODO: Check for ISwiftObject first
        return Self(_transferringRef: pointer)
    }

    public static func get(_ pointer: CPointer) -> Self {
        let projection = get(transferringRef: pointer)
        projection._unknown.addRef()
        return projection
    }

    public static func toSwift(transferringRef pointer: CPointer) -> SwiftType {
        get(transferringRef: pointer)._swiftValue
    }

    public static func toSwift(_ pointer: CPointer) -> SwiftType {
        get(pointer)._swiftValue
    }

    public static func toSwift(transferringRef pointer: CPointer?) throws -> SwiftType {
        guard let pointer else { throw NullResult() }
        return toSwift(transferringRef: pointer)
    }

    public static func toSwift(_ pointer: CPointer?) throws -> SwiftType {
        guard let pointer else { throw NullResult() }
        return toSwift(pointer)
    }
}

// Protocol for strongly-typed two-way COM interface projections into and from Swift.
public protocol COMTwoWayProjection: COMProjection {
    static var _vtable: CVTablePointer { get }
}

// Implemented by a Swift class that should be interoperable with COM.
public protocol COMExport: IUnknownProtocol {
    associatedtype DefaultProjection: COMTwoWayProjection

    // Provides identity for the COM projection of a Swift object.
    // This is what QueryInterface(IUnknown/IInspectable) returns.
    // Should be backed by a weak field that is initialized just-in-time.
    func _getWeakIdentity() -> COMWrapper<DefaultProjection>

    static var projections: [any COMTwoWayProjection.Type] { get }
}

extension COMExport {
    public func _queryInterfacePointer(_ iid: IID) throws -> UnsafeMutablePointer<CWinRT.IUnknown> {
        switch iid {
            case IUnknownProjection.iid, DefaultProjection.iid:
                return _getWeakIdentity().unknownPointer.withAddedRef()

            case IInspectableProjection.iid:
                guard _getWeakIdentity().isInspectable else { throw COMError.noInterface }
                return _getWeakIdentity().unknownPointer.withAddedRef()

            default:
                fatalError()
        }
    }
}
