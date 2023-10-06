import CWinRT
import COM

extension WinRTProjectionBase where Projection: WinRTTwoWayProjection {
    public static func _getIids(
            _ this: Projection.CPointer?,
            _ count: UnsafeMutablePointer<UInt32>?,
            _ iids: UnsafeMutablePointer<UnsafeMutablePointer<IID>?>?) -> HRESULT {
        guard let this, let count, let iids else { return HResult.invalidArg.value }
        count.pointee = 0
        iids.pointee = nil
        let object = _getImplementation(this) as! IInspectable
        return HResult.catchValue {
            let iidsArray = try object.getIids()
            count.pointee = UInt32(iidsArray.count)
            let allocatedIidsPointer = CoTaskMemAlloc(UInt64(MemoryLayout<IID>.stride * iidsArray.count))
            guard let allocatedIidsPointer else { throw HResult.Error.outOfMemory }
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
        guard let this, let className else { return HResult.invalidArg.value }
        className.pointee = nil
        let object = _getImplementation(this) as! IInspectable
        return HResult.catchValue {
            className.pointee = try HStringProjection.toABI(object.getRuntimeClassName())
        }
    }

    public static func _getTrustLevel(
            _ this: Projection.CPointer?,
            _ trustLevel: UnsafeMutablePointer<CWinRT.TrustLevel>?) -> HRESULT {
        guard let this, let trustLevel else { return HResult.invalidArg.value }
        let object = _getImplementation(this) as! IInspectable
        return HResult.catchValue {
            trustLevel.pointee = try TrustLevel.toABI(object.getTrustLevel())
        }
    }
}