import CWinRT

// Protocol for strongly-typed COM interface projections into Swift.
public protocol COMProjection: AnyObject {
    associatedtype SwiftType
    associatedtype CStruct
    associatedtype CVTableStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>
    typealias CVTablePointer = UnsafePointer<CVTableStruct>

    static var iid: IID { get }

    static func _create(_ pointer: CPointer) -> SwiftType
    static func toSwift(_ pointer: CPointer) -> SwiftType
    static func asCOMWithRef(_ object: SwiftType) -> CPointer?
}

extension COMProjection {
    public static func toSwift(_ pointer: CPointer) -> SwiftType {
        // TODO: Check for ISwiftObject first
        _create(pointer)
    }

    public static func toSwift(_ pointer: CPointer?) -> SwiftType? {
        guard let pointer = pointer else { return nil }
        return toSwift(pointer)
    }
}

// Protocol for strongly-typed two-way COM interface projections into and from Swift.
public protocol COMTwoWayProjection: COMProjection {
    static var _vtable: CVTablePointer { get }

    static func toCOMWithRef(_ object: SwiftType) -> CPointer
}

// Implemented by a Swift class that should be interoperable with COM.
public protocol COMExport: IUnknownProtocol {
    static var projections: [any COMTwoWayProjection.Type] { get }
}

extension COMExport {
    public func queryInterface<Projection: COMProjection>(_ iid: IID, _: Projection.Type) throws -> Projection.SwiftType {
        // Self.projections.first { $0.iid == iid }.map { $0.toCOMWithRef(self) }
        throw COMError.noInterface
    }
}
