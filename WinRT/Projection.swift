import CWinRT
import struct Foundation.UUID

protocol COMProjection {
    associatedtype SwiftType
    associatedtype CStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>

    static var iid: CWinRT.IID { get }

    static func toSwift(_ obj: CPointer) throws -> SwiftType
    static func toC(_ obj: SwiftType) throws -> CPointer
}

protocol WinRTActivatableProjection: COMProjection {
    static var activatableId: HString { get }
}
