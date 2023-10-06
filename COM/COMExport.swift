import CWinRT

internal let comExportIID = IID(0x7060261E, 0xB9B8, 0x4290, 0x968D, 0xDEC5D3E22A57)

// Base class for Swift objects exported to COM
open class COMExport<Projection: COMTwoWayProjection>: IUnknownProtocol {
    open class var queriableInterfaces: [QueriableInterface] { [] }

    private var cstruct: CStruct

    public init() {
        cstruct = CStruct()
        cstruct.object = Unmanaged.passUnretained(self)
    }

    internal var pointer: Projection.CPointer {
        withUnsafeMutablePointer(to: &cstruct) {
            $0.withMemoryRebound(to: Projection.CStruct.self, capacity: 1) { $0 }
        }
    }

    internal var unknownPointer: IUnknownPointer {
        withUnsafeMutablePointer(to: &cstruct) {
            IUnknownPointer.cast($0)
        }
    }

    // internal var isInspectable: Bool {
    //     Projection.self is (any WinRTProjection.Type)
    // }

    public final func _queryInterfacePointer(_ iid: IID) throws -> IUnknownPointer {
        try _queryInterfacePointerImpl(iid)
    }

    internal func _queryInterfacePointerImpl(_ iid: IID) throws -> IUnknownPointer {
        switch iid {
            case IUnknownProjection.iid, comExportIID, Projection.iid:
                return unknownPointer.withAddedRef() // The current object is the identity

            // case IInspectableProjection.iid:
            //     guard isInspectable else { throw HResult.Error.noInterface }
            //     return unknownPointer.withAddedRef()

            default:
                guard let interface = Self.queriableInterfaces.first(where: { $0.iid == iid }) else { throw HResult.Error.noInterface }
                return try interface.queryPointer(self)
        }
    }

    private static func cast(_ this: Projection.CPointer) -> UnsafeMutablePointer<CStruct> {
        this.withMemoryRebound(to: CStruct.self, capacity: 1) { $0 }
    }

    internal static func from(_ this: Projection.CPointer) -> COMExport<Projection> {
        cast(this).pointee.object.takeUnretainedValue()
    }

    @discardableResult
    internal static func addRef(_ this: Projection.CPointer) -> UInt32 {
        let this = cast(this)
        _ = this.pointee.object.retain()
        // Best effort refcount
        return UInt32(_getRetainCount(this.pointee.object.takeUnretainedValue()))
    }

    @discardableResult
    internal static func release(_ this: Projection.CPointer) -> UInt32 {
        let this = cast(this)
        let oldRetainCount = _getRetainCount(this.pointee.object.takeUnretainedValue())
        this.pointee.object.release()
        // Best effort refcount
        return UInt32(oldRetainCount - 1)
    }

    internal static func queryInterface(_ this: Projection.CPointer, _ iid: IID) throws -> IUnknownPointer {
        try cast(this).pointee.object.takeUnretainedValue()._queryInterfacePointer(iid)
    }

    private struct CStruct {
        /// Virtual function table called by COM
        public let vtable: Projection.CVTablePointer = Projection.vtable
        public var object: Unmanaged<COMExport<Projection>>! = nil
    }

    public struct QueriableInterface {
        public let iid: IID
        public let queryPointer: (_: COMExport<Projection>) throws -> IUnknownPointer

        public init<TargetProjection: COMTwoWayProjection>(_: TargetProjection.Type) {
            self.iid = TargetProjection.iid
            self.queryPointer = { this in
                let export = COMSecondaryExport<TargetProjection>(implementation: this as! TargetProjection.SwiftType)
                return export.unknownPointer.withAddedRef()
            }
        }
    }
}

internal final class COMSecondaryExport<Projection: COMTwoWayProjection>: COMExport<Projection> {
    private let implementation: Projection.SwiftType

    public init(implementation: Projection.SwiftType) {
        self.implementation = implementation
    }

    internal override func _queryInterfacePointerImpl(_ iid: IID) throws -> IUnknownPointer {
        switch iid {
            case Projection.iid: return unknownPointer.withAddedRef()
            default:
                // Delegate to the main export object
                return try (implementation as! IUnknown)._queryInterfacePointer(iid)
        }
    }
}