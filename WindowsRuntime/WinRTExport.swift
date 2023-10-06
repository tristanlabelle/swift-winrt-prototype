import CWinRT
import COM

open class WinRTExport<Projection: WinRTTwoWayProjection>: COMExport<Projection>, IInspectableProtocol {
    public final func getIids() throws -> [IID] {
        Self.queriableInterfaces.map { $0.iid }
    }

    public func getRuntimeClassName() throws -> String { String(describing: Self.self) }
    public func getTrustLevel() throws -> TrustLevel { CWinRT.BaseTrust }
}