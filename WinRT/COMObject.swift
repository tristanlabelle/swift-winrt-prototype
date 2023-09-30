import CWinRT

open class COMObjectBase {
    public var _unknown: UnsafeMutablePointer<CWinRT.IUnknown> { fatalError() }
}

// Base class for COM objects projected into Swift.
open class COMObject<Projection: COMProjection>: COMObjectBase, IUnknownProtocol {
    public let _pointer: Projection.CPointer
    public override final var _unknown: UnsafeMutablePointer<CWinRT.IUnknown> {
        _pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0 }
    }

    public var _vtable: Projection.CVTableStruct {
        (_unknown.pointee.lpVtbl.withMemoryRebound(to: Projection.CVTableStruct.self, capacity: 1) { $0 }).pointee
    }

    public required init(_wrapping pointer: Projection.CPointer) {
        self._pointer = pointer
        _ = pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0.addRef() }

        super.init()
        assert(self is Projection.SwiftType, "COMObject subclass must be convertible to its SwiftType")
    }

    deinit {
        _ = self._unknown.pointee.lpVtbl.pointee.Release(_unknown)
    }

    public class func _create(_ pointer: Projection.CPointer) -> Projection.SwiftType {
        Self(_wrapping: pointer) as! Projection.SwiftType
    }

    public static func asCOMWithRef(_ object: Projection.SwiftType) -> Projection.CPointer? {
        guard let object = object as? COMObjectBase else { return nil }
        return try? object._unknown.queryInterface(Projection.iid, Projection.CStruct.self)
    }

    private func queryInterface<I: COMProjection>(_: I.Type, _ iid: CWinRT.IID) throws -> I.SwiftType? {
        return I.toSwift(try self._unknown.queryInterface(iid, I.CStruct.self))
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
