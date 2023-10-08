import CWinRT
import COM
import WindowsRuntime

extension WindowsFoundation_AsyncStatus: EnumProjection {
    public typealias CEnum = CWinRT.AsyncStatus
}

public enum WindowsFoundation_AsyncOperationCompletedHandlerProjection<TResult> {}

public final class WindowsFoundation_IAsyncInfoProjection:
        WinRTProjectionBase<WindowsFoundation_IAsyncInfoProjection>, WinRTProjection, WindowsFoundation_IAsyncInfoProtocol {
    public typealias SwiftValue = WindowsFoundation_IAsyncInfo
    public typealias CStruct = CWinRT.IAsyncInfo
    public typealias CVTableStruct = CWinRT.IAsyncInfoVtbl

    public static let iid = IID(0x00000036, 0x0000, 0x0000, 0xC000, 0x000000000046)
    public static var runtimeClassName: String { "Windows.Foundation.IAsyncInfo" }

    public var id: UInt32 { get throws { try _getter(_vtable.get_Id) } }
    public var status: WindowsFoundation_AsyncStatus { get throws { try _getter(_vtable.get_Status, WindowsFoundation_AsyncStatus.self) } }
    public var errorCode: HResult { get throws { try HResult(_getter(_vtable.get_ErrorCode)) } }

    public func cancel() throws { try HResult.throwIfFailed(_vtable.Cancel(_pointer)) }
    public func close() throws { try HResult.throwIfFailed(_vtable.Close(_pointer)) }
}

public enum WindowsFoundation_IAsyncOperationProjection<TResult> {}

public final class WindowsFoundation_IClosableProjection:
        WinRTProjectionBase<WindowsFoundation_IClosableProjection>, WinRTProjection, WindowsFoundation_IClosableProtocol {
    public typealias SwiftValue = WindowsFoundation_IClosable
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIClosable
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIClosableVtbl

    public static let iid = IID(0x30D5A829, 0x7FA4, 0x4026, 0x83BB, 0xD75BAE4EA99E)
    public static var runtimeClassName: String { "Windows.Foundation.IClosable" }

    public func close() throws { try HResult.throwIfFailed(_vtable.Close(_pointer)) }
}

public final class WindowsFoundation_MemoryBuffer:
        WinRTProjectionBase<WindowsFoundation_MemoryBuffer>, WinRTProjection,
        WindowsFoundation_IClosableProtocol {
    public typealias SwiftValue = WindowsFoundation_MemoryBuffer
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBuffer
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBufferVtbl

    public static let iid = IID(0xFBC4DD2A, 0x245B, 0x11E4, 0xAF98, 0x689423260CF8)
    public static var runtimeClassName: String { "Windows.Foundation.MemoryBuffer" }

    private lazy var closable = Result { try queryInterface(WindowsFoundation_IClosableProjection.self) }

    public func close() throws { try closable.get().close() }
}

public enum WindowsFoundation_TypedEventHandlerProjection<TSender, TResult> {}