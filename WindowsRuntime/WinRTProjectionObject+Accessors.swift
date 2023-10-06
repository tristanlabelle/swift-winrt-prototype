import CWinRT
import COM

extension WinRTProjectionObject {
    public func _enumGetter<Enum: EnumProjection>(_ function: (Projection.CPointer, UnsafeMutablePointer<Enum.CEnum>?) -> HRESULT) throws -> Enum {
        Enum(try _getter(function))
    }

    public func _stringGetter(_ function: (Projection.CPointer, UnsafeMutablePointer<CWinRT.HSTRING?>?) -> HRESULT) throws -> String {
        HStringProjection.toSwift(consuming: try _getter(function))
    }
}