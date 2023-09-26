import WinRT

class SwiftBuffer: COMExport, IBufferProtocol, IBufferByteAccessProtocol {
    let bufferPointer: UnsafeMutableBufferPointer<UInt8>

    init(_ array: [UInt8]) {
        bufferPointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: array.count)
        array.copyBytes(to: bufferPointer)
    }

    deinit {
        bufferPointer.deallocate()
    }

    public static let projections: [any COMProjection.Type] = [
        IBufferProjection.self,
        IBufferByteAccessProjection.self
    ]

    public var capacity: UInt32 { get throws { UInt32(bufferPointer.count) } }
    public var length: UInt32 { get throws { UInt32(bufferPointer.count) } }

    public func length(_ value: UInt32) throws {
        fatalError()
    }

    public func buffer() throws -> UnsafeMutablePointer<UInt8>! { bufferPointer.baseAddress }
}