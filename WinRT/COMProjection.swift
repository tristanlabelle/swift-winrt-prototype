import CWinRT
import struct Foundation.UUID

// Protocol for strongly-typed COM interface projections into Swift.
public protocol COMProjection: AnyObject {
    associatedtype SwiftType
    associatedtype CStruct
    associatedtype CVTableStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>
    typealias CVTablePointer = UnsafePointer<CVTableStruct>

    static func toSwift(pointer: CPointer) -> SwiftType

    static var iid: CWinRT.IID { get }
}

// Protocol for strongly-typed two-way COM interface projections into Swift.
public protocol COMImplementable: COMProjection {
    static var _vtable: CVTablePointer { get }
}

// Protocol for strongly-typed WinRT interface/delegate/runtimeclass projections into Swift.
public protocol WinRTProjection: COMProjection {
    static var runtimeClassName: String { get }
}

// Protocol for strongly-typed two-way WinRT interface/delegate/runtimeclass projections into Swift.
public protocol WinRTImplementable: WinRTProjection, COMImplementable {}

protocol WinRTActivatableProjection: COMProjection {
    static var activatableId: String { get }
}
