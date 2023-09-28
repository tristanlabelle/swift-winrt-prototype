import CWinRT

public protocol IUnknownProtocol: AnyObject {
    func queryInterface(_ iid: CWinRT.IID) throws -> IUnknown?
}
public typealias IUnknown = any IUnknownProtocol

public final class IUnknownProjection: COMProjection, IUnknownProtocol {
    public typealias SwiftType = any IUnknownProtocol
    public typealias CStruct = CWinRT.IUnknown
    public typealias CVTableStruct = CWinRT.IUnknownVtbl

    public static let iid = IID(0x00000000, 0x0000, 0x0000, 0xC000, 0x000000000046)

    internal let pointer: UnsafeMutablePointer<CStruct>

    public init(pointer: UnsafeMutablePointer<CStruct>) {
        self.pointer = pointer
        _ = self.pointer.pointee.lpVtbl.pointee.AddRef(pointer)
    }

    public init(object: SwiftType) {
        pointer = COMWrapper<Self>.allocate(object: object, vtable: &Self.vtable)
    }

    deinit {
        _ = self.pointer.pointee.lpVtbl.pointee.Release(pointer)
    }

    public func queryInterface(_ iid: CWinRT.IID) throws -> IUnknown? {
        var iid = iid
        var rawPointer: UnsafeMutableRawPointer?
        let result = self.pointer.pointee.lpVtbl.pointee.QueryInterface(self.pointer, &iid, &rawPointer)
        let unknown = rawPointer?.bindMemory(to: CWinRT.IUnknown.self, capacity: 1)
        defer { _ = unknown?.pointee.lpVtbl.pointee.Release(unknown) }
        if result == COMError.noInterface.hr { return nil }
        try COMError.throwIfFailed(result)
        guard let unknown else { return nil }
        return IUnknownProjection(pointer: unknown)
    }

    private static var vtable: CVTableStruct = .init(
        QueryInterface: { this, iid, ppvObject in
            COMWrapper<IUnknownProjection>.queryInterface(this, iid, ppvObject) {
                object, iid in try object.queryInterface(iid)
            }
        },
        AddRef: { this in COMWrapper<IUnknownProjection>.addRef(this) },
        Release: { this in COMWrapper<IUnknownProjection>.release(this) }
    )
}