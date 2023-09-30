import CWinRT

// Implemented by a Swift class that should be interoperable with COM.
public protocol COMExport: IUnknownProtocol {
    static var projections: [any COMTwoWayProjection.Type] { get }
}

extension COMExport {
    public func queryInterface<Projection: COMProjection>(_ iid: CWinRT.IID, _: Projection.Type) throws -> Projection.SwiftType? {
        // Self.projections.first { $0.iid == iid }.map { $0.toCOMWithRef(self) }
        fatalError()
    }
}

// Implemented by a Swift class that should be interoperable with WinRT.
public protocol WinRTExport: COMExport, IInspectableProtocol {}

extension WinRTExport {
    public func getIids() throws -> [IID] {
        Self.projections.map { $0.iid }
    }

    public func getRuntimeClassName() throws -> String {
        String(describing: Self.self)
    }

    public func getTrustLevel() throws -> CWinRT.TrustLevel {
        CWinRT.BaseTrust
    }
}