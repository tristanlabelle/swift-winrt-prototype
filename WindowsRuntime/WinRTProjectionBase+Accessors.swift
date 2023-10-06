import CWinRT
import COM

extension WinRTProjectionBase {
    public func _enumGetter<Enum: EnumProjection>(_ function: (Projection.CPointer, UnsafeMutablePointer<Enum.CEnum>?) -> HRESULT) throws -> Enum {
        Enum(try _getter(function))
    }

    public func _stringGetter(_ function: (Projection.CPointer, UnsafeMutablePointer<CWinRT.HSTRING?>?) -> HRESULT) throws -> String {
        try _getter(function, HStringProjection.self)
    }
}