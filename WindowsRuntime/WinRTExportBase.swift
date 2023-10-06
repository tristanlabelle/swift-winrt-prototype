import CWinRT
import COM

open class WinRTExportBase<Projection: WinRTTwoWayProjection>
        : COMExportBase<Projection>, IInspectableProtocol {
    open class var _runtimeClassName: String { String(describing: Self.self) }
    open class var _trustLevel: TrustLevel { CWinRT.BaseTrust }
    
    public final func getIids() throws -> [IID] { Self.queriableInterfaces.map { $0.iid } }
    public final func getRuntimeClassName() throws -> String { Self._runtimeClassName }
    public final func getTrustLevel() throws -> TrustLevel { Self._trustLevel }
}