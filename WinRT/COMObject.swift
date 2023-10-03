import CWinRT

open class COMObjectBase {
    public var _unknown: UnsafeMutablePointer<CWinRT.IUnknown> { fatalError() }

    public var _unsafeRefCount: UInt32 {
        let postAddRef = _unknown.pointee.lpVtbl.pointee.AddRef(_unknown)
        let postRelease = _unknown.pointee.lpVtbl.pointee.Release(_unknown)
        assert(postRelease + 1 == postAddRef,
            "Unexpected ref count change during _unsafeRefCount")
        return postRelease
    }

    public static func _getUnsafeRefCount(_ object: IUnknown) -> UInt32 {
        guard let object = object as? COMObjectBase else { return 0 }
        return object._unsafeRefCount
    }
}

// Base class for COM objects projected into Swift.
open class COMObject<Projection: COMProjection>: COMObjectBase, IUnknownProtocol {
    public let _pointer: Projection.CPointer
    public var _swiftObject: Projection.SwiftType { self as! Projection.SwiftType }

    public required init(_transferringRef pointer: Projection.CPointer) {
        self._pointer = pointer
        super.init()
        assert(self is Projection.SwiftType, "COMObject subclass must be convertible to its SwiftType")
    }

    deinit {
        _ = self._unknown.release()
    }

    public override final var _unknown: UnsafeMutablePointer<CWinRT.IUnknown> {
        _pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0 }
    }

    public func queryInterface<I: COMProjection>(_ iid: IID, _: I.Type) throws -> I.SwiftType {
        let pointer = try self._unknown.queryInterface(iid, I.CStruct.self)
        defer { _ = pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0.release() } }
        return I.toSwift(pointer)
    }
}
