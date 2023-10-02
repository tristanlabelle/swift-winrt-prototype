import CWinRT
import WinRT

public final class WindowsFoundationDiagnostics_ErrorDetails:
        WinRTObject<WindowsFoundationDiagnostics_ErrorDetails>, WinRTProjection {
    public typealias SwiftType = WindowsFoundationDiagnostics_ErrorDetails
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetails
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetailsVtbl

    public static let iid = IID(0x378CBB01, 0x2CC9, 0x428F, 0x8C55, 0x2C990D463E8F)
    public static var runtimeClassName: String { "Windows.Foundation.Diagnostics.ErrorDetails" }

    internal static var statics = Result { try _getActivationFactory(WindowsFoundationDiagnostics_IErrorDetailsStatics.self) }
}

internal final class WindowsFoundationDiagnostics_IErrorDetailsStatics:
        WinRTObject<WindowsFoundationDiagnostics_IErrorDetailsStatics>, WinRTProjection {
    public typealias SwiftType = WindowsFoundationDiagnostics_IErrorDetailsStatics
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetailsStatics
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetailsStaticsVtbl

    public static let iid = IID(0xB7703750, 0x0B1D, 0x46C8, 0xAA0E, 0x4B8178E4FCE9)
    public static var runtimeClassName: String { "Windows.Foundation.Diagnostics.IErrorDetailsStatics" }

    public func createFromHResultAsync(_ errorCode: HRESULT) throws -> WindowsFoundation_IAsyncOperation<WindowsFoundationDiagnostics_ErrorDetails> {
        var result: WindowsFoundation_IAsyncOperationProjection<WindowsFoundationDiagnostics_ErrorDetails>.Instance.CPointer?
        try COMError.throwIfFailed(_vtable.CreateFromHResultAsync(_pointer, errorCode, &result))
        return try WindowsFoundation_IAsyncOperationProjection<WindowsFoundationDiagnostics_ErrorDetails>.Instance.toSwift(consumingRef: result)
    }
}

extension WindowsFoundation_IAsyncOperationProjection where TResult == WindowsFoundationDiagnostics_ErrorDetails {
    internal final class Instance: WinRTObject<Instance>, WinRTProjection, WindowsFoundation_IAsyncOperationProtocol {
        public typealias TResult = WindowsFoundationDiagnostics_ErrorDetails
        public typealias SwiftType = WindowsFoundation_IAsyncOperation<TResult>
        public typealias CStruct = CWinRT.__FIAsyncOperation_1_Windows__CFoundation__CDiagnostics__CErrorDetails
        public typealias CVTableStruct = CWinRT.__FIAsyncOperation_1_Windows__CFoundation__CDiagnostics__CErrorDetailsVtbl

        public static let iid = IID(0x9B05106D, 0x77E0, 0x5C24, 0x82B0, 0x9B2DC8F79671)
        public static var runtimeClassName: String { "Windows.Foundation.IAsyncOperation`1<Windows.Foundation.Diagnostics.ErrorDetails>" }
    }
}