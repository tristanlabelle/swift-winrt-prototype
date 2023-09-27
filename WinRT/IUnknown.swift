import CWinRT

public protocol IUnknownProtocol: AnyObject {
    func queryInterface(_ iid: CWinRT.IID) throws -> IUnknown?
}
public typealias IUnknown = any IUnknownProtocol

extension IUnknownProtocol {
    func queryInterface<Projection: COMProjection>(_: Projection.Type) throws -> Projection.SwiftType? {
        guard let unknown = try queryInterface(Projection.iid) else { return nil }
        return (unknown as! Projection.SwiftType) // Parens to ignore forced downcast warning
    }
}