import CWinRT
import WindowsRuntime

extension WindowsFoundation_AsyncOperationCompletedHandlerProjection where TResult == WindowsFoundationDiagnostics_ErrorDetails {
    internal final class Instance: WinRTProjectionBase<Instance>, WinRTProjection {
        public typealias TResult = WindowsFoundationDiagnostics_ErrorDetails
        public typealias SwiftValue = WindowsFoundation_AsyncOperationCompletedHandler<TResult>
        public typealias CStruct = CWinRT.__FIAsyncOperationCompletedHandler_1_Windows__CFoundation__CDiagnostics__CErrorDetails
        public typealias CVTableStruct = CWinRT.__FIAsyncOperationCompletedHandler_1_Windows__CFoundation__CDiagnostics__CErrorDetailsVtbl

        public static let iid = IID(0xA6997F9D, 0x7195, 0x5972, 0x8ECD, 0x1C73AA5CB312)
        public static var runtimeClassName: String { "Windows.Foundation.AsyncOperationCompletedHandler`1<Windows.Foundation.Diagnostics.ErrorDetails>" }
    }
}

extension WindowsFoundation_IAsyncOperationProjection where TResult == WindowsFoundationDiagnostics_ErrorDetails {
    internal final class Instance: WinRTProjectionBase<Instance>, WinRTProjection, WindowsFoundation_IAsyncOperationProtocol {
        public typealias TResult = WindowsFoundationDiagnostics_ErrorDetails
        public typealias SwiftValue = WindowsFoundation_IAsyncOperation<TResult>
        public typealias CStruct = CWinRT.__FIAsyncOperation_1_Windows__CFoundation__CDiagnostics__CErrorDetails
        public typealias CVTableStruct = CWinRT.__FIAsyncOperation_1_Windows__CFoundation__CDiagnostics__CErrorDetailsVtbl

        public static let iid = IID(0x9B05106D, 0x77E0, 0x5C24, 0x82B0, 0x9B2DC8F79671)
        public static var runtimeClassName: String { "Windows.Foundation.IAsyncOperation`1<Windows.Foundation.Diagnostics.ErrorDetails>" }
    }
}