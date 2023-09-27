import CWinRT

internal class SwiftWrapperBase<CStruct>: IUnknownProtocol {
    internal let pointer: UnsafeMutablePointer<CStruct>

    init(_ pointer: UnsafeMutablePointer<CStruct>) {
        self.pointer = pointer
        _ = unknown.pointee.lpVtbl.pointee.AddRef(unknown)
    }

    deinit {
        _ = unknown.pointee.lpVtbl.pointee.Release(unknown)
    }

    internal var unknown: UnsafeMutablePointer<CWinRT.IUnknown> {
        pointer.withMemoryRebound(to: CWinRT.IUnknown.self, capacity: 1) { $0 }
    }

    func queryInterface(_ iid: CWinRT.IID) throws -> IUnknown? {
        var iid = iid
        var rawPointer: UnsafeMutableRawPointer?
        let result = self.unknown.pointee.lpVtbl.pointee.QueryInterface(self.unknown, &iid, &rawPointer)
        let unknown = rawPointer?.bindMemory(to: CWinRT.IUnknown.self, capacity: 1)
        defer { _ = unknown?.pointee.lpVtbl.pointee.Release(unknown) }
        if result == COMError.noInterface.hr { return nil }
        try COMError.throwIfFailed(result)
        guard let unknown else { return nil }
        return try IUnknownProjection.toSwift(unknown)
    }
}