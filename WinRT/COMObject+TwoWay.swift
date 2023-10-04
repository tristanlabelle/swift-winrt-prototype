import CWinRT

extension COMObjectBase where Projection: COMTwoWayProjection {
    public static func _getImplementation(_ pointer: Projection.CPointer) -> Projection.SwiftType {
        COMWrapper<Projection>.from(pointer).implementation
    }

    public static func _getImplementation(_ pointer: Projection.CPointer?) -> Projection.SwiftType? {
        guard let pointer else { return nil }
        return COMWrapper<Projection>.from(pointer).implementation
    }

    public static func _implement(_ this: Projection.CPointer?, _ body: (Projection.SwiftType) throws -> Void) -> HRESULT {
        guard let this else {
            assertionFailure("COM this pointer was null")
            return COMError.invalidArg.hr
        }
        return COMError.catch { try body(_getImplementation(this)) }
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
        _ iid: UnsafePointer<IID>?,
        _ ppvObject: UnsafeMutablePointer<UnsafeMutableRawPointer?>?) -> HRESULT {
        guard let ppvObject else { return COMError.invalidArg.hr }
        ppvObject.pointee = nil

        guard let this, let iid else { return COMError.invalidArg.hr }

        return COMError.catch {
            let unknownWithRef = try COMWrapper<Projection>.queryInterface(this, iid.pointee)
            ppvObject.pointee = UnsafeMutableRawPointer(unknownWithRef)
        }
    }

    public static func _addRef(_ this: Projection.CPointer?) -> UInt32 {
        guard let this else { return 0 }
        return COMWrapper<Projection>.addRef(this)
    }

    public static func _release(_ this: Projection.CPointer?) -> UInt32 {
        guard let this else { return 0 }
        return COMWrapper<Projection>.release(this)
    }
}
