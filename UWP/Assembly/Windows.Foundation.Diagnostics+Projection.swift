import CWinRT
import COM
import WindowsRuntime

public final class WindowsFoundationDiagnostics_ErrorDetails:
        WinRTProjectionBase<WindowsFoundationDiagnostics_ErrorDetails>, WinRTProjection {
    public typealias SwiftValue = WindowsFoundationDiagnostics_ErrorDetails
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetails
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetailsVtbl

    public static let iid = IID(0x378CBB01, 0x2CC9, 0x428F, 0x8C55, 0x2C990D463E8F)
    public static var runtimeClassName: String { "Windows.Foundation.Diagnostics.ErrorDetails" }

    internal static var statics = Result { try _getActivationFactory(WindowsFoundationDiagnostics_IErrorDetailsStatics.self) }
}

internal final class WindowsFoundationDiagnostics_IErrorDetailsStatics:
        WinRTProjectionBase<WindowsFoundationDiagnostics_IErrorDetailsStatics>, WinRTProjection {
    public typealias SwiftValue = WindowsFoundationDiagnostics_IErrorDetailsStatics
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetailsStatics
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetailsStaticsVtbl

    public static let iid = IID(0xB7703750, 0x0B1D, 0x46C8, 0xAA0E, 0x4B8178E4FCE9)
    public static var runtimeClassName: String { "Windows.Foundation.Diagnostics.IErrorDetailsStatics" }

    public func createFromHResultAsync(_ errorCode: HResult) throws -> WindowsFoundation_IAsyncOperation<WindowsFoundationDiagnostics_ErrorDetails> {
        return try NullResult.unwrap(_withOutParam(WindowsFoundation_IAsyncOperationProjection<WindowsFoundationDiagnostics_ErrorDetails>.Instance.self) {
            _vtable.CreateFromHResultAsync(_pointer, errorCode.value, $0)
        })
    }
}
