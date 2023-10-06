import CWinRT

open class COMProjectionObjectBase: IUnknownProtocol {
    public var _unknownPointer: IUnknownPointer { fatalError() }

    fileprivate init() {}

    public var _unsafeRefCount: UInt32 {
        let postAddRef = _unknownPointer.addRef()
        let postRelease = _unknownPointer.release()
        assert(postRelease + 1 == postAddRef,
            "Unexpected ref count change during _unsafeRefCount")
        return postRelease
    }

    public func _queryInterfacePointer(_ iid: IID) throws -> IUnknownPointer {
        try _unknownPointer.queryInterface(iid)
    }

    public static func _getUnsafeRefCount(_ object: IUnknown) -> UInt32 {
        guard let object = object as? COMProjectionObjectBase else { return 0 }
        return object._unsafeRefCount
    }
}

// Base class for COM objects projected into Swift.
open class COMProjectionObject<Projection: COMProjection>: COMProjectionObjectBase {
    public let _pointer: Projection.CPointer
    public var swiftValue: Projection.SwiftType { self as! Projection.SwiftType }

    public required init(transferringRef pointer: Projection.CPointer) {
        self._pointer = pointer
    }

    deinit {
        IUnknownPointer.release(_pointer)
    }

    public override final var _unknownPointer: IUnknownPointer {
        IUnknownPointer.cast(_pointer)
    }
}
