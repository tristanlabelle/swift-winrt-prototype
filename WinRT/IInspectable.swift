import CWinRT

public protocol IInspectableProtocol: IUnknownProtocol {
    func getIids() throws -> [IID]
    func getRuntimeClassName() throws -> String
    func getTrustLevel() throws -> CWinRT.TrustLevel
}
public typealias IInspectable = any IInspectableProtocol

public final class IInspectableProjection: WinRTObject<IInspectableProjection>, WinRTImplementable {
    public typealias SwiftType = IInspectable
    public typealias CStruct = CWinRT.IInspectable
    public typealias CVTableStruct = CWinRT.IInspectableVtbl

    public static let iid = IID(0xAF86E2E0, 0xB12D, 0x4C6A, 0x9C5A, 0xD7AA65101E90)
    public static var runtimeClassName: String { "" }
    public static var _vtable: CVTablePointer { withUnsafePointer(to: &_vtableStruct) { $0 } }
    private static var _vtableStruct: CVTableStruct = .init(
        QueryInterface: { this, iid, ppvObject in _queryInterface(this, iid, ppvObject) },
        AddRef: { this in _addRef(this) },
        Release: { this in _release(this) },
        GetIids: { this, riid, ppvObject in _getIids(this, riid, ppvObject) },
        GetRuntimeClassName: { this, className in _getRuntimeClassName(this, className) },
        GetTrustLevel: { this, trustLevel in _getTrustLevel(this, trustLevel) }
    )
}