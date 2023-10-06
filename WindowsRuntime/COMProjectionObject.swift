import CWinRT

open class COMProjectionObjectBase: IUnknownProtocol {
    public var unknownPointer: UnsafeMutablePointer<CWinRT.IUnknown> { fatalError() }

    fileprivate init() {}

    public var _unsafeRefCount: UInt32 {
        let postAddRef = unknownPointer.addRef()
        let postRelease = unknownPointer.release()
        assert(postRelease + 1 == postAddRef,
            "Unexpected ref count change during _unsafeRefCount")
        return postRelease
    }

    public func _queryInterfacePointer(_ iid: IID) throws -> UnsafeMutablePointer<CWinRT.IUnknown> {
        try unknownPointer.queryInterface(iid)
    }

    public static func _getUnsafeRefCount(_ object: IUnknown) -> UInt32 {
        guard let object = object as? COMProjectionObjectBase else { return 0 }
        return object._unsafeRefCount
    }
}

// Base class for COM objects projected into Swift.
open class COMProjectionObject<Projection: COMProjection>: COMProjectionObjectBase {
    public let pointer: Projection.CPointer
    public var swiftValue: Projection.SwiftType { self as! Projection.SwiftType }

    public required init(transferringRef pointer: Projection.CPointer) {
        self.pointer = pointer
    }

    deinit {
        _ = self.unknownPointer.release()
    }

    public override final var unknownPointer: UnsafeMutablePointer<CWinRT.IUnknown> {
        pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0 }
    }
}
