import CWinRT

public protocol COMExport: IUnknownProtocol {
    static var projections: [any COMProjection.Type] { get }
}

extension COMExport {
    public func queryInterface(_ iid: CWinRT.IID) throws -> IUnknown? {
        if iid == IID_IUnknown { return self }
        guard let projection = Self.projections.first(where: { $0.iid == iid }) else { return nil }
        return nil
    }
}