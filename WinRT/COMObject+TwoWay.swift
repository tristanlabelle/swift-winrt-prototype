import CWinRT

extension COMObject where Projection: COMTwoWayProjection {
    public static func toCOMWithRef(_ object: Projection.SwiftType) -> Projection.CPointer {
        if let pointer = Projection.asCOMWithRef(object) { return pointer }
        return COMWrapper<Projection>.allocate(object: object, vtable: Projection._vtable)
    }

    public static func _getObject(_ pointer: Projection.CPointer?) -> Projection.SwiftType? {
        guard let pointer else { return nil }
        return pointer.withMemoryRebound(to: COMWrapper<Projection>.self, capacity: 1) { $0.pointee.object }
    }

    public static func _getObject(_ pointer: Projection.CPointer) -> Projection.SwiftType {
        pointer.withMemoryRebound(to: COMWrapper<Projection>.self, capacity: 1) { $0.pointee.object }
    }

    public static func _implement(_ this: Projection.CPointer?, _ body: (Projection.SwiftType) throws -> Void) -> HRESULT {
        guard let this else {
            assertionFailure("COM this pointer was null")
            return COMError.invalidArg.hr
        }
        return this.withMemoryRebound(to: COMWrapper<Projection>.self, capacity: 1) { wrapper in
            COMError.catch { try body(wrapper.pointee.object) }
        }
    }

    public static func _getter<Value>(
            _ this: Projection.CPointer?,
            _ value: UnsafeMutablePointer<Value>?,
            _ code: (Projection.SwiftType) throws -> Value) -> HRESULT {
        _implement(this) {
            guard let value else { throw COMError.invalidArg }
            value.pointee = try code($0)
        }
    }

    public static func _queryInterface(
        _ this: Projection.CPointer?,
        _ iid: UnsafePointer<CWinRT.IID>?,
        _ ppvObject: UnsafeMutablePointer<UnsafeMutableRawPointer?>?) -> HRESULT {

        guard let this, let iid, let ppvObject else {
            ppvObject?.pointee = nil
            return COMError.invalidArg.hr
        }

        return this.withMemoryRebound(to: COMWrapper<Projection>.self, capacity: 1) { wrapper -> HRESULT in
            let iid = iid.pointee
            if iid == IUnknownProjection.iid || iid == Projection.iid
                || (iid == IInspectableProjection.iid && Projection.self is (any WinRTProjection).Type) {

                ppvObject.pointee = UnsafeMutableRawPointer(this)
                wrapper.pointee.addRef()
                return 0
            }

            let wrapper = this.withMemoryRebound(to: COMWrapper<Projection>.self, capacity: 1) { $0 }
            ppvObject.pointee = nil
            return COMError.catch {
                let unknown = wrapper.pointee.object as! IUnknown
                if let swiftResult = try unknown.queryInterface(iid, IUnknownProjection.self) {
                    let comResult = IUnknownProjection.toCOMWithRef(swiftResult)
                    ppvObject.pointee = UnsafeMutableRawPointer(comResult)
                }
            }
        }
    }

    public static func _addRef(_ this: Projection.CPointer?) -> UInt32 {
        guard let this else { return 0 }
        return this.withMemoryRebound(to: COMWrapper<Projection>.self, capacity: 1) {
            $0.pointee.addRef()
        }
    }

    public static func _release(_ this: Projection.CPointer?) -> UInt32 {
        guard let this else { return 0 }
        // TODO: Make atomic
        let newRefCount = this.withMemoryRebound(to: COMWrapper<Projection>.self, capacity: 1) {
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
