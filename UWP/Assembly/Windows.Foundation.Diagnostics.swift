import CWinRT
import WinRT

public final class WindowsFoundationDiagnostics_ErrorDetails:
        WinRTObject<WindowsFoundationDiagnostics_ErrorDetails>, WinRTProjection {
    public typealias SwiftType = WindowsFoundationDiagnostics_ErrorDetails
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetails
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetailsVtbl

    public static let iid = IID(0x378CBB01, 0x2CC9, 0x428F, 0x8C55, 0x2C990D463E8F)
    public static var runtimeClassName: String { "Windows.Foundation.Diagnostics.ErrorDetails" }

    public var description: String { get throws { try _stringGetter(_vtable.get_Description) } }
    public var longDescription: String { get throws { try _stringGetter(_vtable.get_LongDescription) } }
    // [propget] HRESULT HelpUri([out] [retval] Windows.Foundation.Uri** value);
}

extension WindowsFoundationDiagnostics_ErrorDetails {
    private static var statics = Result { try _getActivationFactory(WindowsFoundationDiagnostics_IErrorDetailsStatics.self) }

    public static func create(_ errorCode: HRESULT) throws -> WindowsFoundation_IAsyncOperation<WindowsFoundationDiagnostics_ErrorDetails> {
        try statics.get().create(errorCode)
    }
}

fileprivate final class WindowsFoundationDiagnostics_IErrorDetailsStatics:
        WinRTObject<WindowsFoundationDiagnostics_IErrorDetailsStatics>, WinRTProjection {
    public typealias SwiftType = WindowsFoundationDiagnostics_IErrorDetailsStatics
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetailsStatics
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CFoundation_CDiagnostics_CIErrorDetailsStaticsVtbl

    public func create(_ errorCode: HRESULT) throws -> WindowsFoundation_IAsyncOperation<WindowsFoundationDiagnostics_ErrorDetails> {
        //try _objectGetter(_vtable.Create, WindowsFoundationDiagnostics_ErrorDetails.self, hresult)
        fatalError()
    }

    public static let iid = IID(0xB7703750, 0x0B1D, 0x46C8, 0xAA0E, 0x4B8178E4FCE9)
    public static var runtimeClassName: String { "Windows.Foundation.Diagnostics.IErrorDetailsStatics" }
}