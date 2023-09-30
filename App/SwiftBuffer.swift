import WinRT

final class SwiftBuffer: WinRTExport, IBufferProtocol, IBufferByteAccessProtocol {
    let bufferPointer: UnsafeMutableBufferPointer<UInt8>

    init(_ array: [UInt8]) {
        bufferPointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: array.count)
        _ = bufferPointer.initialize(from: array)
    }

    deinit {
        bufferPointer.deallocate()
    }

    public static let projections: [any COMTwoWayProjection.Type] = [
        IBufferProjection.self,
        IBufferByteAccessProjection.self
    ]

    public var capacity: UInt32 { get throws { UInt32(bufferPointer.count) } }
    public var length: UInt32 { get throws { UInt32(bufferPointer.count) } }
    public var buffer: UnsafeMutablePointer<UInt8>! { get throws { bufferPointer.baseAddress } }

    public func length(_ value: UInt32) throws { throw COMError.notImpl }
}