import WinRT
import UWP_WindowsStorageStreams

internal final class SwiftBuffer: WinRTExport, IBufferProtocol, IBufferByteAccessProtocol {
    let bufferPointer: UnsafeMutableBufferPointer<UInt8>

    init(_ array: [UInt8]) {
        bufferPointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: array.count)
        _ = bufferPointer.initialize(from: array)
    }

    deinit {
        bufferPointer.deallocate()
    }

    private weak var _defaultProjection: IBufferProjection?
    var _weakDefaultProjection: IBufferProjection {
        if let projection = _defaultProjection { return projection }
        let projection = IBufferProjection(projecting: self)
        _defaultProjection = projection
        return projection
    }

    public static let projections: [any COMTwoWayProjection.Type] = [
        IBufferProjection.self,
        IBufferByteAccessProjection.self
    ]

    public var capacity: UInt32 { get throws { UInt32(bufferPointer.count) } }
    public var length: UInt32 { get throws { UInt32(bufferPointer.count) } }
    public var buffer: UnsafeMutablePointer<UInt8> { get throws { try NullResult.unwrap(bufferPointer.baseAddress) } }

    public func length(_ value: UInt32) throws { throw COMError.notImpl }
}