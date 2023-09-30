import CWinRT

open class WinRTObject<Projection: WinRTProjection>: COMObject<Projection>, IInspectableProtocol {
    public var _inspectable: UnsafeMutablePointer<CWinRT.IInspectable> {
        _pointer.withMemoryRebound(to: CWinRT.IInspectable.self, capacity: 1) { $0 }
    }

    public func getIids() throws -> [IID] {
        var count: UInt32 = 0
        var iids: UnsafeMutablePointer<IID>?
        let hr = _inspectable.pointee.lpVtbl.pointee.GetIids(_inspectable, &count, &iids)
        defer { CoTaskMemFree(UnsafeMutableRawPointer(iids)) }
        try COMError.throwIfFailed(hr)
        guard let iids else { throw COMError.fail }
        return Array(UnsafeBufferPointer(start: iids, count: Int(count)))
    }

    public func getRuntimeClassName() throws -> String {
        var className: HSTRING?
        let hr = _inspectable.pointee.lpVtbl.pointee.GetRuntimeClassName(_inspectable, &className)
        defer { HSTRING.delete(className) }
        try COMError.throwIfFailed(hr)
        return className.toString()
    }

    public func getTrustLevel() throws -> CWinRT.TrustLevel {
        var trustLevel: CWinRT.TrustLevel = CWinRT.BaseTrust
        let hr = _inspectable.pointee.lpVtbl.pointee.GetTrustLevel(_inspectable, &trustLevel)
        try COMError.throwIfFailed(hr)
        return trustLevel
    }
}