import CWinRT
import WinRT

public final class CryptographicHash: WinRTObject<CryptographicHash>, WinRTProjection {
    public typealias SwiftType = CryptographicHash
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputation
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputationVtbl

    public static let iid = IID(0x5904D1B6, 0xAD31, 0x4603, 0xA3A4, 0xB1BDA98E2562)
    public static var runtimeClassName: String { "Windows.Security.Cryptography.Core.CryptographicHash" }

    public func append(_ data: IBuffer!) throws {
        let data = IBufferProjection.toCOMWithRef(data)
        defer { _ = data.pointee.lpVtbl.pointee.Release(data) }
        try COMError.throwIfFailed(_vtable.Append(_pointer, data))
    }

    public func getValueAndReset() throws -> IBuffer! {
        try _objectGetter(_vtable.GetValueAndReset, IBufferProjection.self)
    }
}

public final class HashAlgorithmProvider: WinRTObject<HashAlgorithmProvider>, WinRTActivatableProjection {
    public typealias SwiftType = HashAlgorithmProvider
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProvider
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderVtbl

    public static let iid = IID(0xBE9B3080, 0xB2C3, 0x422B, 0xBCE1, 0xEC90EFB5D7B5)
    public static var runtimeClassName: String { "Windows.Security.Cryptography.Core.HashAlgorithmProvider" }

    public var algorithmName: String { get throws { try _stringGetter(_vtable.get_AlgorithmName) } }
    public var hashLength: UInt32 { get throws { try _getter(_vtable.get_HashLength) } }

    public func hashData(_ data: IBuffer!) throws -> IBuffer! {
        let data = IBufferProjection.toCOMWithRef(data)
        defer { _ = data.pointee.lpVtbl.pointee.Release(data) }
        var value: IBufferProjection.CPointer?
        try COMError.throwIfFailed(_vtable.HashData(_pointer, data, &value))
        return IBufferProjection.toSwift(value)
    }

    public func createHash() throws -> CryptographicHash! {
        CryptographicHash.toSwift(try _getter(_vtable.CreateHash))
    }
}

extension HashAlgorithmProvider {
    private static var statics = Result { try _getActivationFactory(HashAlgorithmProviderStatics.self) }

    public static func openAlgorithm(_ algorithm: String) throws -> HashAlgorithmProvider! {
        try statics.get().openAlgorithm(algorithm)
    }
}

fileprivate final class HashAlgorithmProviderStatics: WinRTObject<HashAlgorithmProviderStatics>, WinRTProjection {
    public typealias SwiftType = HashAlgorithmProviderStatics
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderStatics
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderStaticsVtbl

    public func openAlgorithm(_ algorithm: String) throws -> HashAlgorithmProvider! {
        let algorithm = try HSTRING.create(algorithm)
        defer { HSTRING.delete(algorithm) }
        var value: HashAlgorithmProvider.CPointer?
        try COMError.throwIfFailed(_vtable.OpenAlgorithm(_pointer, algorithm, &value))
        return HashAlgorithmProvider.toSwift(value)
    }

    public static let iid = IID(0x9FAC9741, 0x5CC4, 0x4336, 0xAE38, 0x6212B75A915A)
    public static var runtimeClassName: String { "Windows.Security.Cryptography.Core.HashAlgorithmProviderStatics" }
}