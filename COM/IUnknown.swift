import CWinRT

public protocol IUnknownProtocol: AnyObject {
    func _queryInterfacePointer(_ iid: IID) throws -> IUnknownPointer
}
public typealias IUnknown = any IUnknownProtocol

extension IUnknownProtocol {
    public func _queryInterfacePointer<Projection: COMProjection>(_: Projection.Type) throws -> Projection.CPointer {
        try _queryInterfacePointer(Projection.iid).withMemoryRebound(to: Projection.CStruct.self, capacity: 1) { $0 }
    }

    public func queryInterface<Projection: COMProjection>(_: Projection.Type) throws -> Projection {
        let pointer = try self._queryInterfacePointer(Projection.iid)
        return pointer.withMemoryRebound(to: Projection.CStruct.self, capacity: 1) {
            return Projection(transferringRef: $0)
        }
    }

    public func tryQueryInterface<Projection: COMProjection>(_: Projection.Type) throws -> Projection? {
       return try NullResult.catch { try self.queryInterface(Projection.self) }
    }
}
