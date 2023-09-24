import CWinRT

internal enum IBufferProjection: COMProjection {
    public typealias SwiftType = IBuffer
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CStorage_CStreams_CIBuffer

    public static var iid: CWinRT.IID { CWinRT.IID___x_ABI_CWindows_CStorage_CStreams_CIBuffer }

    public static func toSwift(_ comPtr: CPointer) -> SwiftType {
        // TODO: Check if the COM pointer is a wrapper
        return SwiftWrapper(comPtr: comPtr)
    }

    public static func toC(_ obj: SwiftType) -> CPointer {
        if let wrapper = obj as? SwiftWrapper { return wrapper.comPtr }
        // TODO: Create a COM wrapper
        fatalError()
    }

    private final class SwiftWrapper: IBufferProtocol {
        internal let comPtr: CPointer

        init(comPtr: CPointer) {
            _ = comPtr.pointee.lpVtbl.pointee.AddRef(comPtr)
            self.comPtr = comPtr
        }

        deinit {
            _ = comPtr.pointee.lpVtbl.pointee.Release(comPtr)
        }

        var capacity: UInt32 {
            get throws {
                var retval: UInt32 = 0
                try COMError.throwIfFailed(comPtr.pointee.lpVtbl.pointee.get_Capacity(comPtr, &retval))
                return retval
            }
        }

        var length: UInt32 {
            get throws {
                var retval: UInt32 = 0
                try COMError.throwIfFailed(comPtr.pointee.lpVtbl.pointee.get_Length(comPtr, &retval))
                return retval
            }
        }

        func length(_ value: UInt32) throws {
            try COMError.throwIfFailed(comPtr.pointee.lpVtbl.pointee.put_Length(comPtr, value))
        }
    }
}

internal enum IHashComputationProjection: COMProjection {
    public typealias SwiftType = IHashComputation
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputation

    public static var iid: CWinRT.IID { CWinRT.IID___x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputation }

    public static func toSwift(_ comPtr: CPointer) -> SwiftType {
        class SwiftWrapper: IHashComputationProtocol {
            private let comPtr: CPointer

            init(comPtr: CPointer) {
                _ = comPtr.pointee.lpVtbl.pointee.AddRef(comPtr)
                self.comPtr = comPtr
            }

            deinit {
                _ = comPtr.pointee.lpVtbl.pointee.Release(comPtr)
            }

            func append(_ data: IBuffer!) throws {
                fatalError()
            }

            func getValueAndReset() throws -> IBuffer! {
                var retval: UnsafeMutablePointer<CWinRT.__x_ABI_CWindows_CStorage_CStreams_CIBuffer>?
                try COMError.throwIfFailed(comPtr.pointee.lpVtbl.pointee.GetValueAndReset(comPtr, &retval))
                return retval.map(IBufferProjection.toSwift)
            }
        }

        return SwiftWrapper(comPtr: comPtr)
    }

    public static func toC(_ obj: SwiftType) -> CPointer { fatalError() }
}

internal enum IHashAlgorithmProviderProjection: COMProjection {
    public typealias SwiftType = IHashAlgorithmProvider
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProvider

    public static var iid: CWinRT.IID { CWinRT.IID___x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProvider }

    public static func toSwift(_ comPtr: CPointer) -> SwiftType {
        class SwiftWrapper: IHashAlgorithmProviderProtocol {
            private let comPtr: CPointer

            init(comPtr: CPointer) {
                _ = comPtr.pointee.lpVtbl.pointee.AddRef(comPtr)
                self.comPtr = comPtr
            }

            deinit {
                _ = comPtr.pointee.lpVtbl.pointee.Release(comPtr)
            }

            var algorithmName: String {
                get throws {
                    var retval: HSTRING? = nil
                    try COMError.throwIfFailed(comPtr.pointee.lpVtbl.pointee.get_AlgorithmName(comPtr, &retval))
                    return HString.toString(consuming: retval)
                }
            }

            var hashLength: UInt32 {
                get throws {
                    var retval: UInt32 = 0
                    try COMError.throwIfFailed(comPtr.pointee.lpVtbl.pointee.get_HashLength(comPtr, &retval))
                    return retval
                }
            }

            func hashData(_ data: IBuffer!) throws -> IBuffer! { fatalError() }

            func createHash() throws -> CryptographicHash! {
                var retval: UnsafeMutablePointer<CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputation>?
                defer { _ = retval?.pointee.lpVtbl.pointee.Release(retval) }
                try COMError.throwIfFailed(comPtr.pointee.lpVtbl.pointee.CreateHash(comPtr, &retval))
                return retval.map(IHashComputationProjection.toSwift).map(CryptographicHash.init)
            }
        }

        return SwiftWrapper(comPtr: comPtr)
    }

    public static func toC(_ obj: SwiftType) -> CPointer { fatalError() }
}

internal enum IHashAlgorithmProviderStaticsProjection: WinRTActivatableProjection {
    public typealias SwiftType = IHashAlgorithmProviderStatics
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderStatics

    public static var activatableId = HString("Windows.Security.Cryptography.Core.HashAlgorithmProvider")
    public static var iid: CWinRT.IID { CWinRT.IID___x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderStatics }

    public static func toSwift(_ ptr: CPointer) -> SwiftType {
        class SwiftWrapper: IHashAlgorithmProviderStaticsProtocol {
            private let ptr: CPointer

            init(_ ptr: CPointer) {
                _ = ptr.pointee.lpVtbl.pointee.AddRef(ptr)
                self.ptr = ptr
            }

            deinit {
                _ = ptr.pointee.lpVtbl.pointee.Release(ptr)
            }

            public func openAlgorithm(_ algorithm: String) throws -> IHashAlgorithmProvider! {
                let algorithm_ = HString(algorithm)
                var retval: UnsafeMutablePointer<CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProvider>?
                defer { _ = retval?.pointee.lpVtbl.pointee.Release(retval) }
                try COMError.throwIfFailed(ptr.pointee.lpVtbl.pointee.OpenAlgorithm(ptr, algorithm_.value, &retval))
                return retval.map(IHashAlgorithmProviderProjection.toSwift)
            }
        }

        return SwiftWrapper(ptr)
    }

    public static func toC(_ obj: SwiftType) -> CPointer { fatalError() }
}