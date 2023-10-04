import CWinRT

public protocol IBufferByteAccessProtocol: IUnknownProtocol {
    var buffer: UnsafeMutablePointer<UInt8> { get throws }
}
public typealias IBufferByteAccess = any IBufferByteAccessProtocol

public final class IBufferByteAccessProjection:
        COMObjectBase<IBufferByteAccessProjection>, COMTwoWayProjection, IBufferByteAccessProtocol {
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

    public var buffer: UnsafeMutablePointer<UInt8> { get throws { try NullResult.unwrap(_getter(_vtable.Buffer)) } }
}