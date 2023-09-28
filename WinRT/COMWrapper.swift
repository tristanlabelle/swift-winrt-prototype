import CWinRT

internal struct COMWrapper<Projection: COMProjection> {
    private static var iid: IID { IID(0x7060261E, 0xB9B8, 0x4290, 0x968D, 0xDEC5D3E22A57) }

    private var object: Projection.SwiftType!
    private var vtable: Projection.CVTablePointer
    private var refCount: UInt32 = 1

    public static func allocate(
            object: Projection.SwiftType,
            vtable: Projection.CVTablePointer)
            -> Projection.CPointer {
        let wrapper = UnsafeMutablePointer<Self>.allocate(capacity: 1)
        wrapper.pointee = COMWrapper(object: object, vtable: vtable)
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

    public static func queryInterface(
            _ this: UnsafeMutablePointer<CWinRT.IUnknown>?,
            _ iid: UnsafePointer<CWinRT.IID>?,
            _ ppvObject: UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
            _ handler: (Projection.SwiftType, CWinRT.IID) throws -> IUnknown?) -> HRESULT {

        guard let this, let iid, let ppvObject else {
            ppvObject?.pointee = nil
            return COMError.invalidArg.hr
        }

        return this.withMemoryRebound(to: COMWrapper.self, capacity: 1) { wrapper -> HRESULT in
            switch iid.pointee {
                case IUnknownProjection.iid, Self.iid:
                    ppvObject.pointee = UnsafeMutableRawPointer(this)
                    wrapper.pointee.addRef()
                    return 0

                // TODO: IInspectable, Projection.iid

                default:
                    let wrapper = this.withMemoryRebound(to: COMWrapper.self, capacity: 1) { $0 }
                    return COMError.catch {
                        guard let result = try handler(wrapper.pointee.object, iid.pointee) else {
                            ppvObject.pointee = nil
                            throw COMError.noInterface
                        }

                        fatalError()
                    }
            }
        }
    }

    public static func addRef(_ this: UnsafeMutablePointer<CWinRT.IUnknown>?) -> UInt32 {
        guard let this else { return 0 }
        return this.withMemoryRebound(to: COMWrapper.self, capacity: 1) {
            $0.pointee.addRef()
        }
    }

    public static func release(_ this: UnsafeMutablePointer<CWinRT.IUnknown>?) -> UInt32 {
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