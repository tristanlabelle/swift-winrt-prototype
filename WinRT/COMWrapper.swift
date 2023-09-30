import CWinRT

// Wraps a Swift object into a COM object with a virtual table.
internal struct COMWrapper<Projection: COMProjection> {
    private static var iid: IID { IID(0x7060261E, 0xB9B8, 0x4290, 0x968D, 0xDEC5D3E22A57) }

    // Must be first for COM layout
    public let vtable: Projection.CVTablePointer
    public var object: Projection.SwiftType!
    public var refCount: UInt32 = 1

    public static func allocate(
            object: Projection.SwiftType,
            vtable: Projection.CVTablePointer)
            -> Projection.CPointer {
        let wrapper = UnsafeMutablePointer<Self>.allocate(capacity: 1)
        wrapper.pointee = COMWrapper(vtable: vtable, object: object)
        return wrapper.withMemoryRebound(to: Projection.CStruct.self, capacity: 1) { $0 }
    }

    public static func unwrap(_ pointer: Projection.CPointer) -> Projection.SwiftType? {
        pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) {
            unknown -> Projection.SwiftType? in
            var iid = Self.iid
            var rawPointer: UnsafeMutableRawPointer?
            guard unknown.pointee.lpVtbl.pointee.QueryInterface(unknown, &iid, &rawPointer) == 0, let rawPointer else { return nil }
            let wrapper = rawPointer.bindMemory(to: Self.self, capacity: 1)
            let object = wrapper.pointee.object
            wrapper.pointee.refCount -= 1 // Undo the QueryInterface AddRef
            return object
        }
    }

    @discardableResult
    public mutating func addRef() -> UInt32 {
        // TODO: Make atomic
        refCount += 1
        return refCount
    }
}