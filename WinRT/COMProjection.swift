import CWinRT
import struct Foundation.UUID

// Protocol for strongly-typed COM interface projections into Swift.
public protocol COMProjection: AnyObject {
    associatedtype SwiftType
    associatedtype CStruct
    associatedtype CVTableStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>
    typealias CVTablePointer = UnsafePointer<CVTableStruct>

    static var iid: CWinRT.IID { get }

    static func _create(_ pointer: CPointer) -> SwiftType
    static func toSwift(_ pointer: CPointer) -> SwiftType
    static func asCOMWithRef(_ object: SwiftType) -> CPointer?
}

extension COMProjection {
    public static func toSwift(_ pointer: CPointer?) -> SwiftType? {
        guard let pointer = pointer else { return nil }
        return toSwift(pointer)
    }
}

// Protocol for strongly-typed two-way COM interface projections into and from Swift.
public protocol COMTwoWayProjection: COMProjection {
    static var _vtable: CVTablePointer { get }
}

// Protocol for strongly-typed WinRT interface/delegate/runtimeclass projections into Swift.
public protocol WinRTProjection: COMProjection {
    static var runtimeClassName: String { get }
}

// Protocol for strongly-typed two-way WinRT interface/delegate/runtimeclass projections into and from Swift.
public protocol WinRTTwoWayProjection: WinRTProjection, COMTwoWayProjection {}

protocol WinRTActivatableProjection: COMProjection {
    static var activatableId: String { get }
}
