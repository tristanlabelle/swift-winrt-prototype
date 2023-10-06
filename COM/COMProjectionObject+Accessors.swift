import CWinRT

extension COMProjectionObject {
    public func _getter<Value>(_ function: (Projection.CPointer, UnsafeMutablePointer<Value>?) -> HRESULT) throws -> Value {
        try withUnsafeTemporaryAllocation(of: Value.self, capacity: 1) { valueBuffer in
            let valuePointer = valueBuffer.baseAddress!
            try HResult.throwIfFailed(function(pointer, valuePointer))
            return valuePointer.pointee
        }
    }

    public func _getter<ValueProjection: ABIProjection>(
            _ function: (Projection.CPointer, UnsafeMutablePointer<ValueProjection.ABIType>?) -> HRESULT,
            _: ValueProjection.Type) throws -> ValueProjection.SwiftType {
        return ValueProjection.toSwift(consuming: try _getter(function))
    }

    public func _objectGetter<ValueProjection: COMProjection>(
            _ function: (Projection.CPointer, UnsafeMutablePointer<ValueProjection.CPointer?>?) -> HRESULT,
            _: ValueProjection.Type) throws -> ValueProjection.SwiftType {
        return ValueProjection.toSwift(consuming: try NullResult.unwrap(_getter(function)))
    }

    public func _setter<Value>(_ function: (Projection.CPointer, Value) -> HRESULT, _ value: Value) throws {
        try HResult.throwIfFailed(function(pointer, value))
    }

    public func _setter<ValueProjection: COMProjection>(
            _ function: (Projection.CPointer, ValueProjection.ABIType) -> HRESULT,
            _ value: ValueProjection.SwiftType,
            _: ValueProjection.Type) throws {
        let abiValue = try ValueProjection.toABI(value)
        defer { ValueProjection.release(abiValue) }
        try _setter(function, abiValue)
    }

    public func _objectSetter<ValueProjection: COMProjection>(
            _ function: (Projection.CPointer, ValueProjection.CPointer?) -> HRESULT,
            _ value: ValueProjection.SwiftType?,
            _: ValueProjection.Type) throws where ValueProjection.SwiftType: IUnknownProtocol {
        if let value {
            let pointerWithRef = try value._queryInterfacePointer(ValueProjection.self)
            defer { _ = IUnknownPointer.release(pointerWithRef) }
            try HResult.throwIfFailed(function(pointer, pointerWithRef))
        }
        else {
            try HResult.throwIfFailed(function(pointer, nil))
        }
    }
}