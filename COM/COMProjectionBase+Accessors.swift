import CWinRT

extension COMProjectionBase {
    public func _getter<Value>(
            _ function: (Projection.CPointer?, UnsafeMutablePointer<Value>?) -> HRESULT) throws -> Value {
        try withUnsafeTemporaryAllocation(of: Value.self, capacity: 1) { valueBuffer in
            let valuePointer = valueBuffer.baseAddress!
            try HResult.throwIfFailed(function(_pointer, valuePointer))
            return valuePointer.pointee
        }
    }

    public func _getter<ValueProjection: ABIProjection>(
            _ function: (Projection.CPointer?, UnsafeMutablePointer<ValueProjection.ABIValue>?) -> HRESULT,
            _: ValueProjection.Type) throws -> ValueProjection.SwiftValue {
        ValueProjection.toSwift(consuming: try _getter(function))
    }

    public func _getter<ValueProjection: ABIProjection>(
            _ function: (Projection.CPointer?, UnsafeMutablePointer<ValueProjection.ABIValue?>?) -> HRESULT,
            _: ValueProjection.Type) throws -> ValueProjection.SwiftValue? {
        try _getter(function, OptionalProjection<ValueProjection>.self)
    }

    public func _setter<Value>(
            _ function: (Projection.CPointer?, Value) -> HRESULT, 
            _ value: Value) throws {
        try HResult.throwIfFailed(function(_pointer, value))
    }

    public func _setter<ValueProjection: ABIProjection>(
            _ function: (Projection.CPointer?, ValueProjection.ABIValue) -> HRESULT,
            _ value: ValueProjection.SwiftValue,
            _: ValueProjection.Type) throws {
        let abiValue = try ValueProjection.toABI(value)
        defer { ValueProjection.release(abiValue) }
        try _setter(function, abiValue)
    }

    public func _setter<ValueProjection: ABIProjection>(
            _ function: (Projection.CPointer?, ValueProjection.ABIValue?) -> HRESULT,
            _ value: ValueProjection.SwiftValue?,
            _: ValueProjection.Type) throws {
        try _setter(function, value, OptionalProjection<ValueProjection>.self)
    }
}