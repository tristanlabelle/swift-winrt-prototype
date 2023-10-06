import CWinRT
import COM

open class WinRTProjectionBase<Projection: WinRTProjection>: COMProjectionBase<Projection>, IInspectableProtocol {
    private var _inspectable: UnsafeMutablePointer<CWinRT.IInspectable> {
        _pointer.withMemoryRebound(to: CWinRT.IInspectable.self, capacity: 1) { $0 }
    }

    public func getIids() throws -> [IID] {
        var count: UInt32 = 0
        var iids: UnsafeMutablePointer<IID>?
        try HResult.throwIfFailed(_inspectable.pointee.lpVtbl.pointee.GetIids(_inspectable, &count, &iids))
        guard let iids else { throw HResult.Error.fail }
        defer { CoTaskMemFree(UnsafeMutableRawPointer(iids)) }
        return Array(UnsafeBufferPointer(start: iids, count: Int(count)))
    }

    public func getRuntimeClassName() throws -> String {
        // Can't use _getter because _pointer is not of type UnsafeMutablePointer<CWinRT.IInspectable>
        var runtimeClassName: HSTRING?
        try HResult.throwIfFailed(_inspectable.pointee.lpVtbl.pointee.GetRuntimeClassName(_inspectable, &runtimeClassName))
        return HStringProjection.toSwift(consuming: runtimeClassName)
    }

    public func getTrustLevel() throws -> TrustLevel {
        // Can't use _getter because _pointer is not of type UnsafeMutablePointer<CWinRT.IInspectable>
        var trustLevel: CWinRT.TrustLevel = CWinRT.BaseTrust
        try HResult.throwIfFailed(_inspectable.pointee.lpVtbl.pointee.GetTrustLevel(_inspectable, &trustLevel))
        return TrustLevel.toSwift(trustLevel)
    }
}