import COM
import WindowsRuntime

extension WindowsFoundationDiagnostics_ErrorDetails {
    public var description: String { get throws { try _getter(_vtable.get_Description, HStringProjection.self) } }
    public var longDescription: String { get throws { try _getter(_vtable.get_LongDescription, HStringProjection.self) } }
    public var helpUri: String { get throws { fatalError() } }

    public static func createFromHResultAsync(_ errorCode: HResult) throws -> WindowsFoundation_IAsyncOperation<WindowsFoundationDiagnostics_ErrorDetails> {
        try statics.get().createFromHResultAsync(errorCode)
    }
}
