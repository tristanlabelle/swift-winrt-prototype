import CWinRT

extension UnsafeMutablePointer where Pointee == CWinRT.IUnknown {
    @discardableResult
    public func addRef() -> UInt32 {
        self.pointee.lpVtbl.pointee.AddRef(self)
    }

    @discardableResult
    public func release() -> UInt32 {
        self.pointee.lpVtbl.pointee.Release(self)
    }

    public func withAddedRef() -> UnsafeMutablePointer<CWinRT.IUnknown> {
        self.addRef()
        return self
    }

    public func queryInterface<CStruct>(_ iid: IID, _ type: CStruct.Type) throws -> UnsafeMutablePointer<CStruct> {
        var iid = iid
        var pointer: UnsafeMutableRawPointer? = nil
        let hr = self.pointee.lpVtbl.pointee.QueryInterface(self, &iid, &pointer)
        guard let pointer else {
            try COMError.throwIfFailed(hr)
            assertionFailure("QueryInterface succeeded but returned a null pointer")
            throw COMError.noInterface
        }

        if COMError.isFailure(hr) {
            assertionFailure("QueryInterface failed but returned a non-null pointer")
            pointer.bindMemory(to: CWinRT.IUnknown.self, capacity: 1).release()
            throw COMError(hr: hr)
        }

        return pointer.bindMemory(to: CStruct.self, capacity: 1)
    }

    public func queryInterface(_ iid: IID) throws -> UnsafeMutablePointer<CWinRT.IUnknown> {
        try self.queryInterface(iid, CWinRT.IUnknown.self)
    }
}