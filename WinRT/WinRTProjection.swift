import CWinRT

// Protocol for strongly-typed WinRT interface/delegate/runtimeclass projections into Swift.
public protocol WinRTProjection: COMProjection {
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
        try COMError.throwIfFailed(hr)
        guard let factory else { throw COMError.noInterface }
        return Factory.toSwift(factory.bindMemory(to: Factory.CStruct.self, capacity: 1))
    }
}

// Implemented by a Swift class that should be interoperable with WinRT.
public protocol WinRTExport: COMExport, IInspectableProtocol {}

extension WinRTExport {
    public func getIids() throws -> [IID] {
        Self.projections.map { $0.iid }
    }

    public func getRuntimeClassName() throws -> String {
        String(describing: Self.self)
    }

    public func getTrustLevel() throws -> CWinRT.TrustLevel {
        CWinRT.BaseTrust
    }
}