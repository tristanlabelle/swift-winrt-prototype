import CWinRT

// Wraps a Swift object into a COM object with a virtual table.
public class COMWrapperBase: IUnknownProtocol {
    internal static var iid: IID { IID(0x7060261E, 0xB9B8, 0x4290, 0x968D, 0xDEC5D3E22A57) }

    internal var unknownPointer: UnsafeMutablePointer<CWinRT.IUnknown> { fatalError() }
    internal var isInspectable: Bool { fatalError() }

    fileprivate init() {}

    public func _queryInterfacePointer(_ iid: IID) throws -> UnsafeMutablePointer<CWinRT.IUnknown> {
        fatalError()
    }
}

public final class COMWrapper<Projection: COMTwoWayProjection>: COMWrapperBase {
    private struct CStruct {
        /// Virtual function table called by COM
        public let vtable: Projection.CVTablePointer = Projection._vtable
        public var this: Unmanaged<COMWrapper<Projection>>! = nil
    }

    private var cstruct: CStruct
    public private(set) var implementation: Projection.SwiftType!
    private let foreignIdentity: COMWrapperBase? // nil if self

    private init(implementation: Projection.SwiftType, foreignIdentity: COMWrapperBase?) {
        self.implementation = implementation
        self.foreignIdentity = foreignIdentity
        self.cstruct = CStruct()
        super.init()
        self.cstruct.this = Unmanaged.passUnretained(self)
    }

    internal var identity: COMWrapperBase { foreignIdentity ?? self }

    internal var pointer: Projection.CPointer {
        withUnsafeMutablePointer(to: &cstruct) {
            $0.withMemoryRebound(to: Projection.CStruct.self, capacity: 1) { $0 }
        }
    }

    internal override var unknownPointer: UnsafeMutablePointer<CWinRT.IUnknown> {
        withUnsafeMutablePointer(to: &cstruct) {
            $0.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0 }
        }
    }

    internal override var isInspectable: Bool {
        Projection.self is (any WinRTProjection.Type)
    }

    public static func createNewIdentity(implementation: Projection.SwiftType) -> Self {
        Self(implementation: implementation, foreignIdentity: nil)
    }

    public override func _queryInterfacePointer(_ iid: IID) throws -> UnsafeMutablePointer<CWinRT.IUnknown> {
        switch iid {
            case Projection.iid, COMWrapperBase.iid: return unknownPointer.withAddedRef() // No-op
            case IUnknownProjection.iid: return identity.unknownPointer.withAddedRef()
            case IInspectableProjection.iid:
                guard identity.isInspectable else { throw COMError.noInterface }
                return identity.unknownPointer.withAddedRef()

            default: return try (implementation as! IUnknown)._queryInterfacePointer(iid)
        }
    }

    internal static func from(_ this: Projection.CPointer) -> COMWrapper {
        this.withMemoryRebound(to: CStruct.self, capacity: 1) {
            $0.pointee.this.takeUnretainedValue()
        }
    }

    @discardableResult
    internal static func addRef(_ this: Projection.CPointer) -> UInt32 {
        this.withMemoryRebound(to: CStruct.self, capacity: 1) {
            _ = $0.pointee.this.retain()
            // Best effort refcount
            return UInt32(_getRetainCount($0.pointee.this.takeUnretainedValue()))
        }
    }

    @discardableResult
    internal static func release(_ this: Projection.CPointer) -> UInt32 {
        this.withMemoryRebound(to: CStruct.self, capacity: 1) {
            let oldRetainCount = _getRetainCount($0.pointee.this.takeUnretainedValue())
            $0.pointee.this.release()
            // Best effort refcount
            return UInt32(oldRetainCount - 1)
        }
    }

    internal static func queryInterface(_ this: Projection.CPointer, _ iid: IID) throws -> UnsafeMutablePointer<CWinRT.IUnknown> {
        try this.withMemoryRebound(to: CStruct.self, capacity: 1) {
            try $0.pointee.this.takeUnretainedValue()._queryInterfacePointer(iid)
        }
    }
}
