import CWinRT
import struct Foundation.UUID

public protocol COMProjection: AnyObject {
    associatedtype SwiftType
    associatedtype CStruct
    associatedtype CVTableStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>
    typealias CVTablePointer = UnsafePointer<CVTableStruct>

    static var iid: CWinRT.IID { get }
}

protocol WinRTActivatableProjection: COMProjection {
    static var activatableId: String { get }
}
