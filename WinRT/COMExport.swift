import CWinRT

public protocol COMExport: IUnknownProtocol {
    static var projections: [any COMProjection.Type] { get }
}
