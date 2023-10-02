import CWinRT
import WinRT

public struct WindowsFoundation_AsyncStatus: WinRTEnum {
    public typealias CEnum = CWinRT.AsyncStatus
    public var value: Int32 = CWinRT.Started.rawValue
    public init(_ value: Int32) { self.value = value }

    public static let started = Self(0)
    public static let completed = Self(1)
    public static let canceled = Self(2)
    public static let error = Self(3)
}

public typealias WindowsFoundation_AsyncOperationCompletedHandler<TResult> = (WindowsFoundation_IAsyncOperation<TResult>, WindowsFoundation_AsyncStatus) -> Void

public protocol WindowsFoundation_IAsyncInfoProtocol: IInspectableProtocol {
    var id: UInt32 { get throws }
    var status: WindowsFoundation_AsyncStatus { get throws }
    var errorCode: HRESULT { get throws }

    func cancel() throws
    func close() throws
}
public typealias WindowsFoundation_IAsyncInfo = any WindowsFoundation_IAsyncInfoProtocol

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

public protocol WindowsFoundation_IAsyncOperationProtocol<TResult>: IInspectableProtocol {
    associatedtype TResult

    var completed: WindowsFoundation_AsyncOperationCompletedHandler<TResult> { get throws }
    func completed(_ value: WindowsFoundation_AsyncOperationCompletedHandler<TResult>!) throws

    func getResults() throws -> TResult;
}
public typealias WindowsFoundation_IAsyncOperation<TResult> = any WindowsFoundation_IAsyncOperationProtocol<TResult>
public enum WindowsFoundation_IAsyncOperationProjection<TResult> {}