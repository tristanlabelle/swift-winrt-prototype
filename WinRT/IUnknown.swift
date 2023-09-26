import CWinRT

public protocol IUnknownProtocol: AnyObject {
    func queryInterface<Projection: COMProjection>(_: Projection.Type) throws -> Projection.SwiftType?
}
public typealias IUnknown = any IUnknownProtocol