import COM
import WindowsRuntime

extension WindowsFoundation_IAsyncOperationProjection<WindowsFoundationDiagnostics_ErrorDetails>.Instance {
    public var completed: WindowsFoundation_AsyncOperationCompletedHandler<TResult> { get throws {
        try NullResult.unwrap(_getter(_vtable.get_Completed, WindowsFoundation_AsyncOperationCompletedHandlerProjection<TResult>.Instance.self))
    } }
    public func completed(_ value: WindowsFoundation_AsyncOperationCompletedHandler<TResult>!) throws {
        fatalError("\(#function) is not implemented")
    }

    public func getResults() throws -> TResult {
        try NullResult.unwrap(_getter(_vtable.GetResults, TResult.self))
    }
}