import CWinRT

open class COMObject: IUnknownProtocol {
    public var _unknown: UnsafeMutablePointer<CWinRT.IUnknown> { fatalError() }

    fileprivate init() {}

    public var _unsafeRefCount: UInt32 {
        let postAddRef = _unknown.addRef()
        let postRelease = _unknown.release()
        assert(postRelease + 1 == postAddRef,
            "Unexpected ref count change during _unsafeRefCount")
        return postRelease
    }

    public func queryInterface<Projection: COMProjection>(_ iid: IID, _: Projection.Type) throws -> Projection {
        let pointerWithRef = try self._unknown.queryInterface(iid, Projection.CStruct.self)
        return Projection(_transferringRef: pointerWithRef)
    }

    public static func _getUnsafeRefCount(_ object: IUnknown) -> UInt32 {
        guard let object = object as? COMObject else { return 0 }
        return object._unsafeRefCount
    }
}

// Base class for COM objects projected into Swift.
open class COMObjectBase<Projection: COMProjection>: COMObject {
    public let _pointer: Projection.CPointer
    public var _swiftValue: Projection.SwiftType { self as! Projection.SwiftType }

    public required init(_transferringRef pointer: Projection.CPointer) {
        self._pointer = pointer
    }

    deinit {
        _ = self._unknown.release()
    }

    public override final var _unknown: UnsafeMutablePointer<CWinRT.IUnknown> {
        _pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0 }
    }
}
