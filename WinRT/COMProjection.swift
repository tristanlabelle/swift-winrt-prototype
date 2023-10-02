import CWinRT

// Protocol for strongly-typed COM interface projections into Swift.
public protocol COMProjection: AnyObject {
    associatedtype SwiftType
    associatedtype CStruct
    associatedtype CVTableStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>
    typealias CVTablePointer = UnsafePointer<CVTableStruct>

    static var iid: IID { get }

    static func _create(consumingRef pointer: CPointer) -> SwiftType
    static func toSwift(consumingRef pointer: CPointer) -> SwiftType
    static func asCOMPointerWithRef(_ object: SwiftType) -> CPointer?
    static func toCOMPointerWithRef(_ object: SwiftType) -> CPointer?
    static func toCOMObject(_ object: SwiftType) -> SwiftType?
}

extension COMProjection {
    public static func _create(_ pointer: CPointer) -> SwiftType {
        _ = pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0.addRef() }
        return _create(consumingRef: pointer)
    }

    public static func toSwift(consumingRef pointer: CPointer) -> SwiftType {
        // TODO: Check for ISwiftObject first
        return _create(consumingRef: pointer)
    }

    public static func toSwift(_ pointer: CPointer) -> SwiftType {
        _ = pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0.addRef() }
        return toSwift(consumingRef: pointer)
    }

    public static func toSwift(consumingRef pointer: CPointer?) throws -> SwiftType {
        guard let pointer else { throw NullResult() }
        return toSwift(consumingRef: pointer)
    }

    public static func toSwift(_ pointer: CPointer?) throws -> SwiftType {
        guard let pointer else { throw NullResult() }
        return toSwift(pointer)
    }

    public static func toCOMPointerWithRef(_ object: SwiftType) -> CPointer? {
        // WinRTTwoWayProjection overrides this
        asCOMPointerWithRef(object)
    }

    public static func toCOMObject(_ object: SwiftType) -> SwiftType? {
        if object is COMObjectBase { return object }
        guard let pointer = toCOMPointerWithRef(object) else { return nil }
        return _create(consumingRef: pointer)
    }
}

// Protocol for strongly-typed two-way COM interface projections into and from Swift.
public protocol COMTwoWayProjection: COMProjection {
    static var _vtable: CVTablePointer { get }
}

extension COMTwoWayProjection {
    public static func toCOMUnknown(_ object: IUnknown) -> IUnknown {
        toCOMObject(object as! SwiftType) as! IUnknown
    }
}

// Implemented by a Swift class that should be interoperable with COM.
public protocol COMExport: IUnknownProtocol {
    static var projections: [any COMTwoWayProjection.Type] { get }
}

extension COMExport {
    public func queryInterface<Projection: COMProjection>(_ iid: IID, _: Projection.Type) throws -> Projection.SwiftType {
        guard Self.projections.first(where: { $0.iid == iid }) != nil else { throw COMError.noInterface }
        guard let swiftInterface = self as? Projection.SwiftType else { throw COMError.noInterface }
        guard let comObject = Projection.toCOMObject(swiftInterface) else { throw COMError.noInterface }
        return comObject
    }
}
