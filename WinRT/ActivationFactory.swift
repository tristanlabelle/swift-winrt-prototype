import CWinRT

internal func getActivationFactory<Projection: WinRTActivatableProjection>(_: Projection.Type) throws -> Projection.SwiftType {
    var iid = Projection.iid
    var factory: UnsafeMutableRawPointer?
    try COMError.throwIfFailed(CWinRT.RoGetActivationFactory(Projection.activatableId.value, &iid, &factory))
    guard let factory else { throw COMError.noInterface }
    return try Projection.toSwift(factory.bindMemory(to: Projection.CStruct.self, capacity: 1))
}