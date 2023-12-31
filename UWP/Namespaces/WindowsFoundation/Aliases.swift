import UWP_Assembly

public typealias AsyncStatus = WindowsFoundation_AsyncStatus

public typealias AsyncOperationCompletedHandler<TResult> = WindowsFoundation_AsyncOperationCompletedHandler<TResult>

public protocol IAsyncInfoProtocol: WindowsFoundation_IAsyncInfoProtocol {}
public typealias IAsyncInfo = WindowsFoundation_IAsyncInfo
public typealias IAsyncInfoProjection = WindowsFoundation_IAsyncInfoProjection

public protocol IAsyncOperationProtocol<TResult>: WindowsFoundation_IAsyncOperationProtocol {}
public typealias IAsyncOperation<TResult> = WindowsFoundation_IAsyncOperation<TResult>
public typealias IAsyncOperationProjection<TResult> = WindowsFoundation_IAsyncOperation<TResult>

public protocol IMemoryBufferReferenceProtocol: WindowsFoundation_IMemoryBufferReferenceProtocol {}
public typealias IMemoryBufferReference = WindowsFoundation_IMemoryBufferReference
public typealias IMemoryBufferReferenceProjection = WindowsFoundation_IMemoryBufferReferenceProjection

public typealias MemoryBuffer = WindowsFoundation_MemoryBuffer

public typealias TypedEventHandler<TSender, TResult> = WindowsFoundation_TypedEventHandler<TSender, TResult>