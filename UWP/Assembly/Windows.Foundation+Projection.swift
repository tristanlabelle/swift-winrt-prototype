import CWinRT
import WindowsRuntime

extension WindowsFoundation_AsyncStatus: WinRTEnum {
    public typealias CEnum = CWinRT.AsyncStatus
}

public enum WindowsFoundation_AsyncOperationCompletedHandlerProjection<TResult> {}

public final class WindowsFoundation_IAsyncInfoProjection:
        WinRTObject<WindowsFoundation_IAsyncInfoProjection>, WinRTProjection, WindowsFoundation_IAsyncInfoProtocol {
    public typealias SwiftType = WindowsFoundation_IAsyncInfo
    public typealias CStruct = CWinRT.IAsyncInfo
    public typealias CVTableStruct = CWinRT.IAsyncInfoVtbl

    public static let iid = IID(0x00000036, 0x0000, 0x0000, 0xC000, 0x000000000046)
    public static var runtimeClassName: String { "Windows.Foundation.IAsyncInfo" }

    public var id: UInt32 { get throws { try _getter(_vtable.get_Id) } }
    public var status: WindowsFoundation_AsyncStatus { get throws { try _enumGetter(_vtable.get_Status) } }
    public var errorCode: HRESULT { get throws { try _getter(_vtable.get_ErrorCode) } }

    public func cancel() throws { try COMError.throwIfFailed(_vtable.Cancel(_pointer)) }
    public func close() throws { try COMError.throwIfFailed(_vtable.Close(_pointer)) }
}