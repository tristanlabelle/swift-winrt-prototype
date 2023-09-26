import CWinRT

public protocol IBufferByteAccessProtocol: IUnknownProtocol {
    func buffer() throws -> UnsafeMutablePointer<UInt8>!
}
public typealias IBufferByteAccess = any IBufferByteAccessProtocol

public protocol IBufferProtocol: IUnknownProtocol {
    var capacity: UInt32 { get throws }
    var length: UInt32 { get throws }
    func length(_ value: UInt32) throws
}
public typealias IBuffer = any IBufferProtocol
