import CWinRT

extension WinRTObject where Projection: WinRTTwoWayProjection {
    public static func _getIids(
            _ this: Projection.CPointer?,
            _ count: UnsafeMutablePointer<UInt32>?,
            _ iids: UnsafeMutablePointer<UnsafeMutablePointer<IID>?>?) -> HRESULT {
        guard let this, let count, let iids else { return COMError.invalidArg.hr }
        count.pointee = 0
        iids.pointee = nil
        let object = _getObject(this) as! IInspectable
        return COMError.catch {
            let iidsArray = try object.getIids()
            count.pointee = UInt32(iidsArray.count)
            let allocatedIidsPointer = CoTaskMemAlloc(UInt64(MemoryLayout<IID>.stride * iidsArray.count))
            guard let allocatedIidsPointer else { throw COMError.outOfMemory }
            let iidsBuffer = UnsafeMutableBufferPointer(
                start: allocatedIidsPointer.bindMemory(to: IID.self, capacity: iidsArray.count),
                count: iidsArray.count)
            _ = iidsBuffer.initialize(from: iidsArray)
            iids.pointee = iidsBuffer.baseAddress
        }
    }

    public static func _getRuntimeClassName(
            _ this: Projection.CPointer?,
            _ className: UnsafeMutablePointer<HSTRING?>?) -> HRESULT {
        guard let this, let className else { return COMError.invalidArg.hr }
        className.pointee = nil
        let object = _getObject(this) as! IInspectable
        return COMError.catch { className.pointee = try HSTRING.allocate(object.getRuntimeClassName()) }
    }

    public static func _getTrustLevel(
            _ this: Projection.CPointer?,
            _ trustLevel: UnsafeMutablePointer<CWinRT.TrustLevel>?) -> HRESULT {
        guard let this, let trustLevel else { return COMError.invalidArg.hr }
        let object = _getObject(this) as! IInspectable
        return COMError.catch { trustLevel.pointee = try object.getTrustLevel() }
    }
}