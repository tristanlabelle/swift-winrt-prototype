import WinRT

extension WindowsFoundationDiagnostics_ErrorDetails {
    public var description: String { get throws { try _stringGetter(_vtable.get_Description) } }
    public var longDescription: String { get throws { try _stringGetter(_vtable.get_LongDescription) } }
    public var helpUri: String { get throws { fatalError() } }

    public static func createFromHResultAsync(_ errorCode: HRESULT) throws -> WindowsFoundation_IAsyncOperation<WindowsFoundationDiagnostics_ErrorDetails> {
        try statics.get().createFromHResultAsync(errorCode)
    }
}

extension WindowsFoundation_IAsyncOperationProjection<WindowsFoundationDiagnostics_ErrorDetails>.Instance {
    public var completed: WindowsFoundation_AsyncOperationCompletedHandler<TResult> { get throws { fatalError() } }
    public func completed(_ value: WindowsFoundation_AsyncOperationCompletedHandler<TResult>!) throws { fatalError() }

    public func getResults() throws -> TResult { try _objectGetter(_vtable.GetResults, TResult.self) }
}