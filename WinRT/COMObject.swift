import CWinRT

public protocol COMProjection: AnyObject {
    associatedtype SwiftType
    associatedtype CStruct
    associatedtype CVTableStruct
    typealias CPointer = UnsafeMutablePointer<CStruct>
    typealias CVTablePointer = UnsafePointer<CVTableStruct>

    static func toSwift(pointer: CPointer) -> SwiftType

    static var iid: CWinRT.IID { get }
    static var vtable: CVTablePointer { get }
}

open class COMObject<Projection: COMProjection>: IUnknownProtocol {
    public let _pointer: Projection.CPointer
    public var _unknown: UnsafeMutablePointer<CWinRT.IUnknown> {
        _pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0 }
    }

    public required init(pointer: Projection.CPointer) {
        self._pointer = pointer
        _ = self._unknown.pointee.lpVtbl.pointee.AddRef(_unknown)
    }

    public required init(object: Projection.SwiftType) {
        _pointer = COMWrapper.allocate(object: object, vtable: Projection.vtable)
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

    public static func _getObject(_ pointer: Projection.CPointer?) -> Projection.SwiftType? {
        guard let pointer else { return nil }
        return pointer.withMemoryRebound(to: COMWrapper.self, capacity: 1) { $0.pointee.object }
    }

    public static func _getObject(_ pointer: Projection.CPointer) -> Projection.SwiftType {
        pointer.withMemoryRebound(to: COMWrapper.self, capacity: 1) { $0.pointee.object }
    }

    public static func _queryInterface(
        _ this: Projection.CPointer?,
        _ iid: UnsafePointer<CWinRT.IID>?,
        _ ppvObject: UnsafeMutablePointer<UnsafeMutableRawPointer?>?) -> HRESULT {

        guard let this, let iid, let ppvObject else {
            ppvObject?.pointee = nil
            return COMError.invalidArg.hr
        }

        return this.withMemoryRebound(to: COMWrapper.self, capacity: 1) { wrapper -> HRESULT in
            switch iid.pointee {
                case IUnknownProjection.iid, Projection.iid:
                    ppvObject.pointee = UnsafeMutableRawPointer(this)
                    wrapper.pointee.addRef()
                    return 0

                // TODO: IInspectable

                default:
                    let wrapper = this.withMemoryRebound(to: COMWrapper.self, capacity: 1) { $0 }
                    fatalError()
            }
        }
    }

    public static func _addRef(_ this: Projection.CPointer?) -> UInt32 {
        guard let this else { return 0 }
        return this.withMemoryRebound(to: COMWrapper.self, capacity: 1) {
            $0.pointee.addRef()
        }
    }

    public static func _release(_ this: Projection.CPointer?) -> UInt32 {
        guard let this else { return 0 }
        // TODO: Make atomic
        let newRefCount = this.withMemoryRebound(to: COMWrapper.self, capacity: 1) {
            $0.pointee.refCount -= 1
            if $0.pointee.refCount == 0 {
                $0.pointee.object = nil
            }
            return $0.pointee.refCount
        }
        if newRefCount == 0 { this.deallocate() }
        return newRefCount
    }
}