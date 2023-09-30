import CWinRT

public final class CryptographicHash: WinRTObject<CryptographicHash>, WinRTProjection {
    public typealias SwiftType = CryptographicHash
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputation
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputationVtbl

    public func append(_ data: IBuffer!) throws {
        let data = IBufferProjection.toCOMWithRef(data)
        defer { _ = data.pointee.lpVtbl.pointee.Release(data) }
        try COMError.throwIfFailed(_vtable.Append(_pointer, data))
    }

    public func getValueAndReset() throws -> IBuffer! {
        IBufferProjection.toSwift(try _getter(_vtable.GetValueAndReset))
    }

    public static let iid = IID(0x5904D1B6, 0xAD31, 0x4603, 0xA3A4, 0xB1BDA98E2562)
    public static var runtimeClassName: String { "Windows.Security.Cryptography.Core.CryptographicHash" }
}

public final class HashAlgorithmProvider: WinRTObject<HashAlgorithmProvider>, WinRTProjection {
    public typealias SwiftType = HashAlgorithmProvider
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProvider
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderVtbl

    public var algorithmName: String { get throws { HSTRING.toStringAndDelete(try _getter(_vtable.get_AlgorithmName)) } }
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

    public static let iid = IID(0xBE9B3080, 0xB2C3, 0x422B, 0xBCE1, 0xEC90EFB5D7B5)
    public static var runtimeClassName: String { "Windows.Security.Cryptography.Core.HashAlgorithmProvider" }
}

// internal protocol IHashAlgorithmProviderStaticsProtocol: IUnknownProtocol {
//     func openAlgorithm(_ algorithm: String) throws -> IHashAlgorithmProvider!
// }
// internal typealias IHashAlgorithmProviderStatics = any IHashAlgorithmProviderStaticsProtocol

// extension HashAlgorithmProvider {
//     private static var statics = Result { try getActivationFactory(IHashAlgorithmProviderStaticsProjection.self) }

//     public static func openAlgorithm(_ algorithm: String) throws -> HashAlgorithmProvider! {
//         HashAlgorithmProvider(try statics.get().openAlgorithm(algorithm))
//     }
// }