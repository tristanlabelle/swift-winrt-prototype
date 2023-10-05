import WindowsRuntime

extension WindowsFoundationDiagnostics_ErrorDetails {
    public var description: String { get throws { try _stringGetter(_vtable.get_Description) } }
    public var longDescription: String { get throws { try _stringGetter(_vtable.get_LongDescription) } }
    public var helpUri: String { get throws { fatalError() } }

    public static func createFromHResultAsync(_ errorCode: HRESULT) throws -> WindowsFoundation_IAsyncOperation<WindowsFoundationDiagnostics_ErrorDetails> {
        try statics.get().createFromHResultAsync(errorCode)
    }
}
