public protocol COMExport: IUnknownProtocol {
    static var projections: [any COMProjection.Type] { get }
}

extension COMExport {
    public func queryInterface<Projection: COMProjection>(_: Projection.Type) throws -> Projection.SwiftType? {
        if Projection.self == IUnknownProjection.self {
            fatalError()
        }
        for projection in Self.projections {
            if projection.iid == Projection.iid {
                fatalError()
            }
        }
        return nil
    }
}