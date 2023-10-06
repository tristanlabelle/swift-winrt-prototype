import CWinRT

extension COMProjectionBase where Projection: COMTwoWayProjection {
    public static func _getImplementation(_ pointer: Projection.CPointer) -> Projection.SwiftType {
        COMExport<Projection>.from(pointer) as! Projection.SwiftType
    }

    public static func _getImplementation(_ pointer: Projection.CPointer?) -> Projection.SwiftType? {
        guard let pointer else { return nil }
        return (COMExport<Projection>.from(pointer) as! Projection.SwiftType)
    }

    public static func _implement(_ this: Projection.CPointer?, _ body: (Projection.SwiftType) throws -> Void) -> HRESULT {
        guard let this else {
            assertionFailure("COM this pointer was null")
            return HResult.invalidArg.value
        }
        return HResult.catchValue { try body(_getImplementation(this)) }
    }

    public static func _getter<Value>(
            _ this: Projection.CPointer?,
            _ value: UnsafeMutablePointer<Value>?,
            _ code: (Projection.SwiftType) throws -> Value) -> HRESULT {
        _implement(this) {
            guard let value else { throw HResult.Error.invalidArg }
            value.pointee = try code($0)
        }
    }

    public static func _queryInterface(
        _ this: Projection.CPointer?,
        _ iid: UnsafePointer<IID>?,
        _ ppvObject: UnsafeMutablePointer<UnsafeMutableRawPointer?>?) -> HRESULT {
        guard let ppvObject else { return HResult.invalidArg.value }
        ppvObject.pointee = nil

        guard let this, let iid else { return HResult.invalidArg.value }

        return HResult.catchValue {
            let unknownWithRef = try COMExport<Projection>.queryInterface(this, iid.pointee)
            ppvObject.pointee = UnsafeMutableRawPointer(unknownWithRef)
        }
    }

    public static func _addRef(_ this: Projection.CPointer?) -> UInt32 {
        guard let this else { return 0 }
        return COMExport<Projection>.addRef(this)
    }

    public static func _release(_ this: Projection.CPointer?) -> UInt32 {
        guard let this else { return 0 }
        return COMExport<Projection>.release(this)
    }
}
