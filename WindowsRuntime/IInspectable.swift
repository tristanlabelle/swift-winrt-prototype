import CWinRT
import COM

public protocol IInspectableProtocol: IUnknownProtocol {
    func getIids() throws -> [IID]
    func getRuntimeClassName() throws -> String
    func getTrustLevel() throws -> CWinRT.TrustLevel
}
public typealias IInspectable = any IInspectableProtocol
