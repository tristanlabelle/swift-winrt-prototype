import CWinRT

extension COMObject {
    public func _getter<Value>(_ function: (Projection.CPointer, UnsafeMutablePointer<Value>?) -> HRESULT) throws -> Value {
        try withUnsafeTemporaryAllocation(of: Value.self, capacity: 1) { valueBuffer in
            let valuePointer = valueBuffer.baseAddress!
            try COMError.throwIfFailed(function(_pointer, valuePointer))
            return valuePointer.pointee
        }
    }

    public func _enumGetter<Enum: WinRTEnum>(_ function: (Projection.CPointer, UnsafeMutablePointer<Enum.CEnum>?) -> HRESULT) throws -> Enum {
        Enum(try _getter(function))
    }

    public func _stringGetter(_ function: (Projection.CPointer, UnsafeMutablePointer<CWinRT.HSTRING?>?) -> HRESULT) throws -> String {
        HSTRING.toStringAndDelete(try _getter(function))
    }

    public func _objectGetter<ValueProjection: COMProjection>(
            _ function: (Projection.CPointer, UnsafeMutablePointer<ValueProjection.CPointer?>?) -> HRESULT,
            _: ValueProjection.Type) throws -> ValueProjection.SwiftType {
        guard let pointer = try _getter(function) else { throw NullResult() }
        defer { _ = pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0.release() } }
        return ValueProjection.toSwift(pointer)
    }

    public func _setter<Value>(_ function: (Projection.CPointer, Value) -> HRESULT, _ value: Value) throws {
        try COMError.throwIfFailed(function(_pointer, value))
    }

    public func _objectSetter<ValueProjection: COMProjection>(
            _ function: (Projection.CPointer, ValueProjection.CPointer?) -> HRESULT,
            _ value: ValueProjection.SwiftType?,
            _: ValueProjection.Type) throws {
        guard let value else {
            try COMError.throwIfFailed(function(_pointer, nil))
            return
        }

        guard let valuePointer = ValueProjection.toCOMPointerWithRef(value) else {
            fatalError("Unprojectable value")
        }
        defer { _ = valuePointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0.release() } }

        try COMError.throwIfFailed(function(_pointer, valuePointer))
    }
}