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

// internal protocol IHashAlgorithmProviderProtocol: IUnknownProtocol {
//     var algorithmName: String { get throws }
//     var hashLength: UInt32 { get throws }
//     func hashData(_ data: IBuffer!) throws -> IBuffer!
//     func createHash() throws -> CryptographicHash!
// }
// internal typealias IHashAlgorithmProvider = any IHashAlgorithmProviderProtocol

// internal protocol IHashAlgorithmProviderStaticsProtocol: IUnknownProtocol {
//     func openAlgorithm(_ algorithm: String) throws -> IHashAlgorithmProvider!
// }
// internal typealias IHashAlgorithmProviderStatics = any IHashAlgorithmProviderStaticsProtocol

// public class HashAlgorithmProvider {
//     private let impl: IHashAlgorithmProvider

//     internal init(_ impl: IHashAlgorithmProvider) {
//         self.impl = impl
//     }

//     public var algorithmName: String { get throws { try impl.algorithmName } }
//     public var hashLength: UInt32 { get throws { try impl.hashLength } }
//     public func hashData(_ data: IBuffer!) throws -> IBuffer! { try impl.hashData(data) }
//     public func createHash() throws -> CryptographicHash! { try impl.createHash() }
// }

// extension HashAlgorithmProvider {
//     private static var statics = Result { try getActivationFactory(IHashAlgorithmProviderStaticsProjection.self) }

//     public static func openAlgorithm(_ algorithm: String) throws -> HashAlgorithmProvider! {
//         HashAlgorithmProvider(try statics.get().openAlgorithm(algorithm))
//     }
// }