import CWinRT
import struct Foundation.UUID

protocol WinRTActivatableProjection: COMProjection {
    static var activatableId: String { get }
}
