
import CWinRT

public enum IUnknownProjection: COMProjection {
    public typealias SwiftType = IUnknown
    public typealias CStruct = CWinRT.IUnknown

    public static var iid: CWinRT.IID { CWinRT.IID_IUnknown }

    public static func toSwift(_ pointer: CPointer) -> SwiftType {
        return SwiftWrapperBase(pointer)
    }

    public static func toC(_ obj: SwiftType) -> CPointer { fatalError() }
}