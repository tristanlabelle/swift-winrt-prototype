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
    static func _create(_ pointer: CPointer) -> SwiftType
    static func toSwift(_ pointer: CPointer) -> SwiftType
    static func asCOMPointerWithRef(_ object: SwiftType) -> CPointer?
    static func toCOMObject(_ object: SwiftType) -> SwiftType?
}

extension COMProjection {
    public static func _create(_ pointer: CPointer) -> SwiftType {
        _ = pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0.addRef() }
        return _create(consumingRef: pointer)
    }

    public static func toSwift(_ pointer: CPointer) -> SwiftType {
        // TODO: Check for ISwiftObject first
        _create(pointer)
    }

    public static func toSwift(_ pointer: CPointer?) -> SwiftType? {
        guard let pointer = pointer else { return nil }
        return toSwift(pointer)
    }

    public static func toCOMObject(_ object: SwiftType) -> SwiftType? {
        object is COMObjectBase ? Optional(object) : nil
    }
}

// Protocol for strongly-typed two-way COM interface projections into and from Swift.
public protocol COMTwoWayProjection: COMProjection {
    static var _vtable: CVTablePointer { get }

    static func toCOMPointerWithRef(_ object: SwiftType) -> CPointer
}

extension COMTwoWayProjection {
    public static func toCOMObject(_ object: SwiftType) -> SwiftType? {
        if object is COMObjectBase { return object }
        let pointer = toCOMPointerWithRef(object)
        return _create(consumingRef: pointer)
    }

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
