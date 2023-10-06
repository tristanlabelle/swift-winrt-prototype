import CWinRT

// Protocol for strongly-typed WinRT interface/delegate/runtimeclass projections into Swift.
public protocol WinRTProjection: COMProjection, IInspectableProtocol {
    static var runtimeClassName: String { get }
}

// Protocol for strongly-typed two-way WinRT interface/delegate/runtimeclass projections into and from Swift.
public protocol WinRTTwoWayProjection: WinRTProjection, COMTwoWayProjection {}

extension WinRTProjection {
    public static func _getActivationFactory<Factory: WinRTProjection>(_: Factory.Type) throws -> Factory.SwiftType {
        let activatableId = try HSTRING.create(Self.runtimeClassName)
        defer { HSTRING.delete(activatableId) }
        var iid = Factory.iid
        var factory: UnsafeMutableRawPointer?
        let hr = CWinRT.RoGetActivationFactory(activatableId, &iid, &factory)
        let unknown = factory?.bindMemory(to: CWinRT.IUnknown.self, capacity: 1)
        defer { _ = unknown?.pointee.lpVtbl.pointee.Release(unknown) }
        try HResult.throwIfFailed(hr)
        guard let factory else { throw HResult.Error.noInterface }
        return Factory.toSwift(copying: factory.bindMemory(to: Factory.CStruct.self, capacity: 1))
    }
}
