import COM
import WindowsRuntime

extension WindowsSecurityCryptographyCore_CryptographicHash {
    public func append(_ data: WindowsStorageStreams_IBuffer!) throws {
        let data = try data._queryInterfacePointer(WindowsStorageStreams_IBufferProjection.self)
        defer { _ = data.pointee.lpVtbl.pointee.Release(data) }
        try HResult.throwIfFailed(vtable.Append(pointer, data))
    }

    public func getValueAndReset() throws -> WindowsStorageStreams_IBuffer {
        try _objectGetter(vtable.GetValueAndReset, WindowsStorageStreams_IBufferProjection.self)
    }
}

extension WindowsSecurityCryptographyCore_HashAlgorithmProvider {
    public var algorithmName: String { get throws { try _stringGetter(vtable.get_AlgorithmName) } }
    public var hashLength: UInt32 { get throws { try _getter(vtable.get_HashLength) } }

    public func hashData(_ data: WindowsStorageStreams_IBuffer!) throws -> WindowsStorageStreams_IBuffer {
        let data = try data._queryInterfacePointer(WindowsStorageStreams_IBufferProjection.self)
        defer { WindowsStorageStreams_IBufferProjection.release(data) }
        var value: WindowsStorageStreams_IBufferProjection.CPointer?
        try HResult.throwIfFailed(vtable.HashData(pointer, data, &value))
        return try NullResult.unwrap(WindowsStorageStreams_IBufferProjection.toSwift(consuming: value))
    }

    public func createHash() throws -> WindowsSecurityCryptographyCore_CryptographicHash {
        try _objectGetter(vtable.CreateHash, WindowsSecurityCryptographyCore_CryptographicHash.self)
    }

    public static func openAlgorithm(_ algorithm: String) throws -> WindowsSecurityCryptographyCore_HashAlgorithmProvider {
        try statics.get().openAlgorithm(algorithm)
    }
}
