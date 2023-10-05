import WindowsRuntime

public protocol WindowsStorageStreams_IBufferProtocol: IInspectableProtocol {
    var capacity: UInt32 { get throws }
    var length: UInt32 { get throws }
    func length(_ value: UInt32) throws
}
public typealias WindowsStorageStreams_IBuffer = any WindowsStorageStreams_IBufferProtocol
