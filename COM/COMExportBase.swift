open class COMExportBase<Projection: COMTwoWayProjection>: IUnknownProtocol {
    open class var queriableInterfaces: [COMExportInterface] { [] }

    public private(set) weak var _comExport: COMExport<Projection>?

    public init() {}

    public func _getCOMExport() -> COMExport<Projection> {
        if let _comExport { return _comExport }
        let newComExport = COMExport<Projection>(
            implementation: self as! Projection.SwiftValue,
            queriableInterfaces: Self.queriableInterfaces)
        _comExport = newComExport
        return newComExport
    }

    public func _queryInterfacePointer(_ iid: IID) throws -> IUnknownPointer {
        return try _getCOMExport()._queryInterfacePointer(iid)
    }
}