import CWinRT

public protocol IUnknownProtocol: AnyObject {
    func queryInterface<Projection: COMProjection>(_ iid: CWinRT.IID, _: Projection.Type) throws -> Projection.SwiftType?
}
public typealias IUnknown = any IUnknownProtocol

extension IUnknownProtocol {
    public func queryInterface<Projection: COMProjection>(_: Projection.Type) throws -> Projection.SwiftType? {
        try self.queryInterface(Projection.iid, Projection.self)
    }
}

public final class IUnknownProjection: COMObject<IUnknownProjection>, COMTwoWayProjection {
    public typealias SwiftType = IUnknown
    public typealias CStruct = CWinRT.IUnknown
    public typealias CVTableStruct = CWinRT.IUnknownVtbl

    public static let iid = IID(0x00000000, 0x0000, 0x0000, 0xC000, 0x000000000046)
    public static var _vtable: CVTablePointer { withUnsafePointer(to: &_vtableStruct) { $0 } }
    private static var _vtableStruct: CVTableStruct = .init(
        QueryInterface: { this, iid, ppvObject in _queryInterface(this, iid, ppvObject) },
        AddRef: { this in _addRef(this) },
        Release: { this in _release(this) }
    )
}

extension UnsafeMutablePointer where Pointee == CWinRT.IUnknown {
    @discardableResult
    public func addRef() -> UInt32 {
        self.pointee.lpVtbl.pointee.AddRef(self)
    }

    @discardableResult
    public func release() -> UInt32 {
        self.pointee.lpVtbl.pointee.Release(self)
    }

    public func queryInterface<CStruct>(_ iid: CWinRT.IID, _ type: CStruct.Type) throws -> UnsafeMutablePointer<CStruct>? {
        var iid = iid
        var pointer: UnsafeMutableRawPointer?
        let hr = self.pointee.lpVtbl.pointee.QueryInterface(self, &iid, &pointer)
        guard let pointer else {
            if hr == COMError.noInterface.hr { return nil }
            try COMError.throwIfFailed(hr)
            assertionFailure("QueryInterface succeeded but returned a null pointer")
            return nil
        }

        return pointer.bindMemory(to: CStruct.self, capacity: 1)
    }

    public func queryInterface(_ iid: CWinRT.IID) throws -> UnsafeMutablePointer<CWinRT.IUnknown>? {
        try self.queryInterface(iid, CWinRT.IUnknown.self)
    }
}