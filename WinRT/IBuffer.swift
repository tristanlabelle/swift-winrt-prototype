import CWinRT

public protocol IBufferProtocol: IInspectableProtocol {
    var capacity: UInt32 { get throws }
    var length: UInt32 { get throws }
    func length(_ value: UInt32) throws
}
public typealias IBuffer = any IBufferProtocol

public final class IBufferProjection: WinRTObject<IBufferProjection>, WinRTTwoWayProjection, IBufferProtocol {
    public typealias SwiftType = IBuffer
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CStorage_CStreams_CIBuffer
    public typealias CVTableStruct = CWinRT.__x_ABI_CWindows_CStorage_CStreams_CIBufferVtbl

    public static let iid = IID(0x905A0FE0, 0xBC53, 0x11DF, 0x8C49, 0x001E4FC686DA)
    public static var runtimeClassName: String { "Windows.Storage.Streams.IBuffer" }
    public static var _vtable: CVTablePointer { withUnsafePointer(to: &_vtableStruct) { $0 } }
    private static var _vtableStruct: CVTableStruct = .init(
        QueryInterface: { this, iid, ppvObject in _queryInterface(this, iid, ppvObject) },
        AddRef: { this in _addRef(this) },
        Release: { this in _release(this) },
        GetIids: { this, riid, ppvObject in _getIids(this, riid, ppvObject) },
        GetRuntimeClassName: { this, className in _getRuntimeClassName(this, className) },
        GetTrustLevel: { this, trustLevel in _getTrustLevel(this, trustLevel) },
        get_Capacity: { this, value in _getter(this, value) { try $0.capacity } },
        get_Length: { this, value in _getter(this, value) { try $0.length } },
        put_Length: { this, value in _implement(this) { try $0.length(value) } }
    )

    public var capacity: UInt32 { get throws { try _getter(_vtable.get_Capacity) } }
    public var length: UInt32 { get throws { try _getter(_vtable.get_Length) } }
    public func length(_ value: UInt32) throws { try _setter(_vtable.put_Length, value) }
}

public protocol IBufferByteAccessProtocol: IUnknownProtocol {
    var buffer: UnsafeMutablePointer<UInt8>! { get throws }
}
public typealias IBufferByteAccess = any IBufferByteAccessProtocol

public final class IBufferByteAccessProjection: COMObject<IBufferByteAccessProjection>, COMTwoWayProjection, IBufferByteAccessProtocol {
    public typealias SwiftType = IBufferByteAccess
    public typealias CStruct = CWinRT.IBufferByteAccess
    public typealias CVTableStruct = CWinRT.IBufferByteAccessVtbl

    public static let iid = IID(0x905A0FEF, 0xBC53, 0x11DF, 0x8C49, 0x001E4FC686DA)
    public static var _vtable: CVTablePointer { withUnsafePointer(to: &_vtableStruct) { $0 } }
    private static var _vtableStruct: CVTableStruct = .init(
        QueryInterface: { this, iid, ppvObject in _queryInterface(this, iid, ppvObject) },
        AddRef: { this in _addRef(this) },
        Release: { this in _release(this) },
        Buffer: { this, value in _getter(this, value) { try $0.buffer } }
    )

    public var buffer: UnsafeMutablePointer<UInt8>! { get throws { try _getter(_vtable.Buffer) } }
}