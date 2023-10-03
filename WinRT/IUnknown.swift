import CWinRT

public protocol IUnknownProtocol: AnyObject {
    func queryInterface<Projection: COMProjection>(_ iid: IID, _: Projection.Type) throws -> Projection.SwiftType
}
public typealias IUnknown = any IUnknownProtocol

extension IUnknownProtocol {
    public func queryInterface<Projection: COMProjection>(_: Projection.Type) throws -> Projection.SwiftType {
        try self.queryInterface(Projection.iid, Projection.self)
    }

    public func tryQueryInterface<Projection: COMProjection>(_ iid: IID, _: Projection.Type) throws -> Projection.SwiftType? {
        do { return try self.queryInterface(iid, Projection.self) }
        catch let error as COMError where error.hr == COMError.noInterface.hr { return nil }
        catch { throw error }
    }

    public func tryQueryInterface<Projection: COMProjection>(_: Projection.Type) throws -> Projection.SwiftType? {
       try tryQueryInterface(Projection.iid, Projection.self)
    }
}
