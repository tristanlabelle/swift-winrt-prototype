import CWinRT

// 905a0fef-bc53-11df-8c49-001e4fc686da
public protocol IBufferByteAccessProtocol {
    func buffer() throws -> UnsafeMutablePointer<UInt8>
}

public protocol IBufferProtocol {
    var capacity: UInt32 { get throws }
    var length: UInt32 { get throws }
    func length(_ value: UInt32) throws
}
public typealias IBuffer = any IBufferProtocol

internal protocol IHashComputationProtocol {
    func append(_ data: IBuffer!) throws
    func getValueAndReset() throws -> IBuffer!
}
internal typealias IHashComputation = any IHashComputationProtocol

public class CryptographicHash {
    private let impl: IHashComputation

    internal init(_ impl: IHashComputation) {
        self.impl = impl
    }

    public func append(_ data: IBuffer!) throws { try impl.append(data) }
    public func getValueAndReset() throws -> IBuffer! { try impl.getValueAndReset() }
}

internal protocol IHashAlgorithmProviderProtocol: AnyObject {
    var algorithmName: String { get throws }
    var hashLength: UInt32 { get throws }
    func hashData(_ data: IBuffer!) throws -> IBuffer!
    func createHash() throws -> CryptographicHash!
}
internal typealias IHashAlgorithmProvider = any IHashAlgorithmProviderProtocol

internal protocol IHashAlgorithmProviderStaticsProtocol: AnyObject {
    func openAlgorithm(_ algorithm: String) throws -> IHashAlgorithmProvider!
}
internal typealias IHashAlgorithmProviderStatics = any IHashAlgorithmProviderStaticsProtocol

public class HashAlgorithmProvider {
    private let impl: IHashAlgorithmProvider

    internal init(_ impl: IHashAlgorithmProvider) {
        self.impl = impl
    }

    public var algorithmName: String { get throws { try impl.algorithmName } }
    public var hashLength: UInt32 { get throws { try impl.hashLength } }
    public func hashData(_ data: IBuffer!) throws -> IBuffer! { try impl.hashData(data) }
    public func createHash() throws -> CryptographicHash! { try impl.createHash() }
}

extension HashAlgorithmProvider {
    private static var statics = Result { try getActivationFactory(IHashAlgorithmProviderStaticsProjection.self) }

    public static func openAlgorithm(_ algorithm: String) throws -> HashAlgorithmProvider! {
        HashAlgorithmProvider(try statics.get().openAlgorithm(algorithm))
    }
}