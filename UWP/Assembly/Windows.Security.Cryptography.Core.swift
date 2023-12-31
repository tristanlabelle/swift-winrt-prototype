import COM
import WindowsRuntime

extension WindowsSecurityCryptographyCore_CryptographicHash {
    public func append(_ data: WindowsStorageStreams_IBuffer!) throws {
        let data = try data._queryInterfacePointer(WindowsStorageStreams_IBufferProjection.self)
        defer { WindowsStorageStreams_IBufferProjection.release(data) }
        try HResult.throwIfFailed(_vtable.Append(_pointer, data))
    }

    public func getValueAndReset() throws -> WindowsStorageStreams_IBuffer {
        try NullResult.unwrap(_getter(_vtable.GetValueAndReset, WindowsStorageStreams_IBufferProjection.self))
    }
}

extension WindowsSecurityCryptographyCore_HashAlgorithmProvider {
    public var algorithmName: String { get throws { try _getter(_vtable.get_AlgorithmName, HStringProjection.self) } }
    public var hashLength: UInt32 { get throws { try _getter(_vtable.get_HashLength) } }

    public func hashData(_ data: WindowsStorageStreams_IBuffer!) throws -> WindowsStorageStreams_IBuffer {
        let data = try data._queryInterfacePointer(WindowsStorageStreams_IBufferProjection.self)
        defer { WindowsStorageStreams_IBufferProjection.release(data) }
        var value: WindowsStorageStreams_IBufferProjection.CPointer?
        try HResult.throwIfFailed(_vtable.HashData(_pointer, data, &value))
        return try NullResult.unwrap(WindowsStorageStreams_IBufferProjection.toSwift(consuming: value))
    }

    public func createHash() throws -> WindowsSecurityCryptographyCore_CryptographicHash {
        try NullResult.unwrap(_getter(_vtable.CreateHash, WindowsSecurityCryptographyCore_CryptographicHash.self))
    }

    public static func openAlgorithm(_ algorithm: String) throws -> WindowsSecurityCryptographyCore_HashAlgorithmProvider {
        try statics.get().openAlgorithm(algorithm)
    }
}
