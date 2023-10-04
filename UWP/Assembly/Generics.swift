import WinRT

extension WindowsFoundation_IAsyncOperationProjection<WindowsFoundationDiagnostics_ErrorDetails>.Instance {
    public var completed: WindowsFoundation_AsyncOperationCompletedHandler<TResult> { get throws {
        try _objectGetter(_vtable.get_Completed, WindowsFoundation_AsyncOperationCompletedHandlerProjection<TResult>.Instance.self)
    } }
    public func completed(_ value: WindowsFoundation_AsyncOperationCompletedHandler<TResult>!) throws {
        fatalError("\(#function) is not implemented")
    }

    public func getResults() throws -> TResult { try _objectGetter(_vtable.GetResults, TResult.self) }
}