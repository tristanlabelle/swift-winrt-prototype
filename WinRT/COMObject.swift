import CWinRT

// Base class for COM objects projected into Swift.
open class COMObject<Projection: COMProjection>: IUnknownProtocol {
    public let _pointer: Projection.CPointer
    public var _unknown: UnsafeMutablePointer<CWinRT.IUnknown> {
        _pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0 }
    }

    public var _vtable: Projection.CVTableStruct {
        (_unknown.pointee.lpVtbl.withMemoryRebound(to: Projection.CVTableStruct.self, capacity: 1) { $0 }).pointee
    }

    public required init(pointer: Projection.CPointer) {
        self._pointer = pointer
        _ = self._unknown.pointee.lpVtbl.pointee.AddRef(_unknown)
    }

    public static func toSwift(pointer: Projection.CPointer) -> Projection.SwiftType {
        // TODO: Check for ISwiftObject first
        Self(pointer: pointer) as! Projection.SwiftType
    }

    deinit {
        _ = self._unknown.pointee.lpVtbl.pointee.Release(_unknown)
    }

    private func queryInterface<I: COMProjection>(_: I.Type, _ iid: CWinRT.IID) throws -> I.SwiftType? {
        var iid = iid
        var rawPointer: UnsafeMutableRawPointer?
        let hr = self._unknown.pointee.lpVtbl.pointee.QueryInterface(self._unknown, &iid, &rawPointer)
        let unknown = rawPointer?.bindMemory(to: CWinRT.IUnknown.self, capacity: 1)
        defer { _ = unknown?.pointee.lpVtbl.pointee.Release(unknown) }
        if hr == COMError.noInterface.hr { return nil }
        try COMError.throwIfFailed(hr)
        guard let rawPointer else { return nil }
        return I.toSwift(pointer: rawPointer.bindMemory(to: I.CStruct.self, capacity: 1))
    }

    public func queryInterface<I: COMProjection>(_ projection: I) throws -> I.SwiftType? {
        try self.queryInterface(I.self, I.iid)
    }

    public func queryInterface(_ iid: CWinRT.IID) throws -> IUnknown? {
        try self.queryInterface(IUnknownProjection.self, iid)
    }

    public func _getter<Value>(_ function: (Projection.CPointer, UnsafeMutablePointer<Value>?) -> HRESULT) throws -> Value {
        try withUnsafeTemporaryAllocation(of: Value.self, capacity: 1) { valueBuffer in
            let valuePointer = valueBuffer.baseAddress!
            try COMError.throwIfFailed(function(_pointer, valuePointer))
            return valuePointer.pointee
        }
    }

    public func _setter<Value>(_ function: (Projection.CPointer, Value) -> HRESULT, _ value: Value) throws {
        try COMError.throwIfFailed(function(_pointer, value))
    }
}