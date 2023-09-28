import CWinRT

internal enum IHashComputationProjection: COMProjection {
    public typealias SwiftType = IHashComputation
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputation

    public static var iid: CWinRT.IID { CWinRT.IID___x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputation }

    public static func toSwift(_ pointer: CPointer) -> SwiftType { SwiftWrapper(pointer) }
    public static func toC(_ obj: SwiftType) -> CPointer { fatalError() }

    private final class SwiftWrapper: SwiftWrapperBase<CStruct>, IHashComputationProtocol {
        func append(_ data: IBuffer!) throws {
            fatalError()
        }

        func getValueAndReset() throws -> IBuffer! {
            var retval: UnsafeMutablePointer<CWinRT.__x_ABI_CWindows_CStorage_CStreams_CIBuffer>?
            try COMError.throwIfFailed(pointer.pointee.lpVtbl.pointee.GetValueAndReset(pointer, &retval))
            return retval.map(IBufferProjection.toSwift)
        }
    }
}

internal enum IHashAlgorithmProviderProjection: COMProjection {
    public typealias SwiftType = IHashAlgorithmProvider
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProvider

    public static var iid: CWinRT.IID { CWinRT.IID___x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProvider }

    public static func toSwift(_ pointer: CPointer) -> SwiftType { SwiftWrapper(pointer) }
    public static func toC(_ obj: SwiftType) -> CPointer { fatalError() }

    private final class SwiftWrapper: SwiftWrapperBase<CStruct>, IHashAlgorithmProviderProtocol {
        var algorithmName: String {
            get throws {
                var retval: HSTRING? = nil
                try COMError.throwIfFailed(pointer.pointee.lpVtbl.pointee.get_AlgorithmName(pointer, &retval))
                return HString.toString(consuming: retval)
            }
        }

        var hashLength: UInt32 {
            get throws {
                var retval: UInt32 = 0
                try COMError.throwIfFailed(pointer.pointee.lpVtbl.pointee.get_HashLength(pointer, &retval))
                return retval
            }
        }

        func hashData(_ data: IBuffer!) throws -> IBuffer! { fatalError() }

        func createHash() throws -> CryptographicHash! {
            var retval: UnsafeMutablePointer<CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashComputation>?
            defer { _ = retval?.pointee.lpVtbl.pointee.Release(retval) }
            try COMError.throwIfFailed(pointer.pointee.lpVtbl.pointee.CreateHash(pointer, &retval))
            return retval.map(IHashComputationProjection.toSwift).map(CryptographicHash.init)
        }
    }
}

internal enum IHashAlgorithmProviderStaticsProjection: WinRTActivatableProjection {
    public typealias SwiftType = IHashAlgorithmProviderStatics
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderStatics

    public static var activatableId = HString("Windows.Security.Cryptography.Core.HashAlgorithmProvider")
    public static var iid: CWinRT.IID { CWinRT.IID___x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProviderStatics }

    public static func toSwift(_ pointer: CPointer) -> SwiftType { SwiftWrapper(pointer) }
    public static func toC(_ obj: SwiftType) -> CPointer { fatalError() }

    private final class SwiftWrapper: SwiftWrapperBase<CStruct>, IHashAlgorithmProviderStaticsProtocol {
        public func openAlgorithm(_ algorithm: String) throws -> IHashAlgorithmProvider! {
            let algorithm_ = HString(algorithm)
            var retval: UnsafeMutablePointer<CWinRT.__x_ABI_CWindows_CSecurity_CCryptography_CCore_CIHashAlgorithmProvider>?
            defer { _ = retval?.pointee.lpVtbl.pointee.Release(retval) }
            try COMError.throwIfFailed(pointer.pointee.lpVtbl.pointee.OpenAlgorithm(pointer, algorithm_.value, &retval))
            return retval.map(IHashAlgorithmProviderProjection.toSwift)
        }
    }
}