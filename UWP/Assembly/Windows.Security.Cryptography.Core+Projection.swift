import CWinRT
import COM
import WindowsRuntime

public final class WindowsSecurityCryptographyCore_CryptographicHash:
        WinRTProjectionBase<WindowsSecurityCryptographyCore_CryptographicHash>, WinRTProjection {
    public typealias SwiftValue = WindowsSecurityCryptographyCore_CryptographicHash
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputation
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputationVtbl

    public static let iid = IID(0x5904D1B6, 0xAD31, 0x4603, 0xA3A4, 0xB1BDA98E2562)
    public static var runtimeClassName: String { "Windows.Security.Cryptography.Core.CryptographicHash" }
}

public final class WindowsSecurityCryptographyCore_HashAlgorithmProvider:
        WinRTProjectionBase<WindowsSecurityCryptographyCore_HashAlgorithmProvider>, WinRTProjection {
    public typealias SwiftValue = WindowsSecurityCryptographyCore_HashAlgorithmProvider
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProvider
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderVtbl

    public static let iid = IID(0xBE9B3080, 0xB2C3, 0x422B, 0xBCE1, 0xEC90EFB5D7B5)
    public static var runtimeClassName: String { "Windows.Security.Cryptography.Core.HashAlgorithmProvider" }

    internal static var statics = Result { try _getActivationFactory(WindowsSecurityCryptographyCore_HashAlgorithmProviderStatics.self) }
}

internal final class WindowsSecurityCryptographyCore_HashAlgorithmProviderStatics:
        WinRTProjectionBase<WindowsSecurityCryptographyCore_HashAlgorithmProviderStatics>, WinRTProjection {
    public typealias SwiftValue = WindowsSecurityCryptographyCore_HashAlgorithmProviderStatics
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderStatics
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderStaticsVtbl

    public func openAlgorithm(_ algorithm: String) throws -> WindowsSecurityCryptographyCore_HashAlgorithmProvider {
        let algorithm = try HStringProjection.toABI(algorithm)
        defer { HStringProjection.release(algorithm) }
        return try NullResult.unwrap(_withOutParam(WindowsSecurityCryptographyCore_HashAlgorithmProvider.self) {
            _vtable.OpenAlgorithm(_pointer, algorithm, $0)
        })
    }

    public static let iid = IID(0x9FAC9741, 0x5CC4, 0x4336, 0xAE38, 0x6212B75A915A)
    public static var runtimeClassName: String { "Windows.Security.Cryptography.Core.HashAlgorithmProviderStatics" }
}