import COM
import WindowsRuntime

public struct WindowsFoundation_AsyncStatus: Hashable {
    public var value: Int32
    public init(_ value: Int32 = 0) { self.value = value }

    public static let started = Self(0)
    public static let completed = Self(1)
    public static let canceled = Self(2)
    public static let error = Self(3)
}

public typealias WindowsFoundation_AsyncOperationCompletedHandler<TResult> = (WindowsFoundation_IAsyncOperation<TResult>, WindowsFoundation_AsyncStatus) -> Void

public protocol WindowsFoundation_IAsyncInfoProtocol: IInspectableProtocol {
    var id: UInt32 { get throws }
    var status: WindowsFoundation_AsyncStatus { get throws }
    var errorCode: HResult { get throws }

    func cancel() throws
    func close() throws
}
public typealias WindowsFoundation_IAsyncInfo = any WindowsFoundation_IAsyncInfoProtocol

public protocol WindowsFoundation_IAsyncOperationProtocol<TResult>: IInspectableProtocol {
    associatedtype TResult

    var completed: WindowsFoundation_AsyncOperationCompletedHandler<TResult> { get throws }
    func completed(_ value: WindowsFoundation_AsyncOperationCompletedHandler<TResult>!) throws

    func getResults() throws -> TResult;
}
public typealias WindowsFoundation_IAsyncOperation<TResult> = any WindowsFoundation_IAsyncOperationProtocol<TResult>

public protocol WindowsFoundation_IClosableProtocol: IInspectableProtocol {
    func close() throws
}
public typealias WindowsFoundation_IClosable = any WindowsFoundation_IClosableProtocol

public protocol WindowsFoundation_IMemoryBufferReferenceProtocol: IInspectableProtocol, WindowsFoundation_IClosableProtocol {
    var capacity: UInt32 { get throws }
    func add_Closed(_ handler: WindowsFoundation_TypedEventHandler<WindowsFoundation_IMemoryBufferReference?, IInspectable?>!) throws -> EventRegistrationToken
    func remove_Closed(_ cookie: EventRegistrationToken) throws
}
public typealias WindowsFoundation_IMemoryBufferReference = any WindowsFoundation_IMemoryBufferReferenceProtocol

extension WindowsFoundation_MemoryBuffer: WindowsFoundation_IClosableProtocol {}

public typealias WindowsFoundation_TypedEventHandler<TSender, TResult> = (_ sender: TSender, _ args: TResult) throws -> Void