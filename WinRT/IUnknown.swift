import CWinRT

public protocol IUnknownProtocol: AnyObject {
    func queryInterface(_ iid: CWinRT.IID) throws -> IUnknown?
}
public typealias IUnknown = any IUnknownProtocol

public final class IUnknownProjection: COMObject<IUnknownProjection>, COMProjection {
    public typealias SwiftType = any IUnknownProtocol
    public typealias CStruct = CWinRT.IUnknown
    public typealias CVTableStruct = CWinRT.IUnknownVtbl

    public static let iid = IID(0x00000000, 0x0000, 0x0000, 0xC000, 0x000000000046)

    public static var vtable: CVTablePointer { withUnsafePointer(to: &_vtable) { $0 } }
    private static var _vtable: CVTableStruct = .init(
        QueryInterface: { this, iid, ppvObject in _queryInterface(this, iid, ppvObject) },
        AddRef: { this in _addRef(this) },
        Release: { this in _release(this) }
    )
}