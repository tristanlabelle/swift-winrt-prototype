import COM
import WindowsRuntime
import UWP_WindowsStorageStreams

internal final class SwiftBuffer: WinRTExport<IBufferProjection>, IBufferProtocol, IBufferByteAccessProtocol {
    public override class var queriableInterfaces: [QueriableInterface] { [
        .init(IBufferProjection.self),
        .init(IBufferByteAccessProjection.self)
    ] }

    let bufferPointer: UnsafeMutableBufferPointer<UInt8>

    init(_ array: [UInt8]) {
        bufferPointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: array.count)
        _ = bufferPointer.initialize(from: array)
    }

    deinit {
        bufferPointer.deallocate()
    }

    public var capacity: UInt32 { get throws { UInt32(bufferPointer.count) } }
    public var length: UInt32 { get throws { UInt32(bufferPointer.count) } }
    public var buffer: UnsafeMutablePointer<UInt8> { get throws { try NullResult.unwrap(bufferPointer.baseAddress) } }

    public func length(_ value: UInt32) throws { throw HResult.Error.notImpl }
}