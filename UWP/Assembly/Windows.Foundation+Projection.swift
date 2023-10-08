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
        WinRTProjectionBase<WindowsFoundation_MemoryBuffer>, WinRTProjection {
    public typealias SwiftValue = WindowsFoundation_MemoryBuffer
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBuffer
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBufferVtbl

    public static let iid = IID(0xFBC4DD2A, 0x245B, 0x11E4, 0xAF98, 0x689423260CF8)
    public static var runtimeClassName: String { "Windows.Foundation.MemoryBuffer" }

    public func createReference() throws -> WindowsFoundation_IMemoryBufferReference {
        var result: UnsafeMutablePointer<CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBufferReference>?
        try HResult.throwIfFailed(_vtable.CreateReference(_pointer, &result))
        return try NullResult.unwrap(WindowsFoundation_IMemoryBufferReferenceProjection.toSwift(consuming: result))
    }

    private lazy var closable = Result { try queryInterface(WindowsFoundation_IClosableProjection.self) }

    public func close() throws { try closable.get().close() }

    internal static var factory = Result { try _getActivationFactory(WindowsFoundation_IMemoryBufferFactory.self) }

    public static func create(_ capacity: UInt32) throws -> WindowsFoundation_MemoryBuffer {
        try self.factory.get().create(capacity)
    }
}

internal final class WindowsFoundation_IMemoryBufferFactory:
        WinRTProjectionBase<WindowsFoundation_IMemoryBufferFactory>, WinRTProjection {
    public typealias SwiftValue = WindowsFoundation_IMemoryBufferFactory
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBufferFactory
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBufferFactoryVtbl

    public static let iid = IID(0xFBC4DD2B, 0x245B, 0x11E4, 0xAF98, 0x689423260CF8)
    public static var runtimeClassName: String { "Windows.Foundation.IMemoryBufferFactory" }

    public func create(_ capacity: UInt32) throws -> WindowsFoundation_MemoryBuffer {
        var result: UnsafeMutablePointer<CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBuffer>?
        try HResult.throwIfFailed(_vtable.Create(_pointer, capacity, &result))
        return try NullResult.unwrap(WindowsFoundation_MemoryBuffer.toSwift(consuming: result))
    }
}

public final class WindowsFoundation_IMemoryBufferReferenceProjection:
        WinRTProjectionBase<WindowsFoundation_IMemoryBufferReferenceProjection>, WinRTProjection,
        WindowsFoundation_IMemoryBufferReferenceProtocol {
    public typealias SwiftValue = WindowsFoundation_IMemoryBufferReference
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBufferReference
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CIMemoryBufferReferenceVtbl

    public static let iid = IID(0xFBC4DD29, 0x245B, 0x11E4, 0xAF98, 0x689423260CF8)
    public static var runtimeClassName: String { "Windows.Foundation.IMemoryBufferReference" }

    public var capacity: UInt32 { get throws { try _getter(_vtable.get_Capacity) } }
    public func add_Closed(_ handler: WindowsFoundation_TypedEventHandler<WindowsFoundation_IMemoryBufferReference?, WindowsRuntime.IInspectable?>!) throws -> WindowsRuntime.EventRegistrationToken {
        let handler = try WindowsFoundation_TypedEventHandlerProjection<WindowsFoundation_IMemoryBufferReference?, WindowsRuntime.IInspectable?>.Instance.toABI(handler)
        defer { WindowsFoundation_TypedEventHandlerProjection<WindowsFoundation_IMemoryBufferReference?, WindowsRuntime.IInspectable?>.Instance.release(handler) }
        var result: CWinRT.EventRegistrationToken = .init()
        try HResult.throwIfFailed(_vtable.add_Closed(_pointer, handler, &result))
        return WindowsRuntime.EventRegistrationToken.toSwift(result)
    }
    public func remove_Closed(_ cookie: WindowsRuntime.EventRegistrationToken) throws {
        let cookie = try WindowsRuntime.EventRegistrationToken.toABI(cookie)
        defer { WindowsRuntime.EventRegistrationToken.release(cookie) }
        try HResult.throwIfFailed(_vtable.remove_Closed(_pointer, cookie))
    }

    private lazy var closable = Result { try queryInterface(WindowsFoundation_IClosableProjection.self) }

    public func close() throws { try closable.get().close() }
}

public enum WindowsFoundation_TypedEventHandlerProjection<TSender, TResult> {}

extension WindowsFoundation_TypedEventHandlerProjection
        where TSender == WindowsFoundation_IMemoryBufferReference?, TResult == WindowsRuntime.IInspectable? {
    internal final class Instance: WinRTDelegateProjectionBase<Instance>, COMTwoWayProjection {
        public typealias SwiftValue = WindowsFoundation_TypedEventHandler<TSender, TResult>
        public typealias CStruct = CWinRT.__FITypedEventHandler_2_Windows__CFoundation__CIMemoryBufferReference_IInspectable
        public typealias CVTableStruct = CWinRT.__FITypedEventHandler_2_Windows__CFoundation__CIMemoryBufferReference_IInspectableVtbl

        public static let iid = IID(0xF4637D4A, 0x0760, 0x5431, 0xBFC0, 0x24EB1D4F6C4F)
        public static var vtable: CVTablePointer { withUnsafePointer(to: &vtableStruct) { $0 } }
        private static var vtableStruct: CVTableStruct = .init(
            QueryInterface: { this, iid, ppvObject in _queryInterface(this, iid, ppvObject) },
            AddRef: { this in _addRef(this) },
            Release: { this in _release(this) },
            Invoke: { this, sender, args in _implement(this) { handler in
                let sender = WindowsFoundation_IMemoryBufferReferenceProjection.toSwift(copying: sender)
                let args = WindowsRuntime.IInspectableProjection.toSwift(copying: args)
                try handler(sender, args)
            } }
        )
    }
}