import CWinRT

public enum IBufferProjection: COMProjection {
    public typealias SwiftType = IBuffer
    public typealias CStruct = CWinRT.__x_ABI_CWindows_CStorage_CStreams_CIBuffer

    public static var iid: CWinRT.IID { CWinRT.IID___x_ABI_CWindows_CStorage_CStreams_CIBuffer }

    public static func toSwift(_ pointer: CPointer) -> SwiftType {
        // TODO: Check if the COM pointer is a wrapper
        return SwiftWrapper(pointer)
    }

    public static func toC(_ obj: SwiftType) -> CPointer {
        if let wrapper = obj as? SwiftWrapper { return wrapper.pointer }
        // TODO: Create a COM wrapper
        fatalError()
    }

    private final class SwiftWrapper: SwiftWrapperBase<CStruct>, IBufferProtocol {
        var capacity: UInt32 {
            get throws {
                var retval: UInt32 = 0
                try COMError.throwIfFailed(pointer.pointee.lpVtbl.pointee.get_Capacity(pointer, &retval))
                return retval
            }
        }

        var length: UInt32 {
            get throws {
                var retval: UInt32 = 0
                try COMError.throwIfFailed(pointer.pointee.lpVtbl.pointee.get_Length(pointer, &retval))
                return retval
            }
        }

        func length(_ value: UInt32) throws {
            try COMError.throwIfFailed(pointer.pointee.lpVtbl.pointee.put_Length(pointer, value))
        }
    }
}

public enum IBufferByteAccessProjection: COMProjection {
    public typealias SwiftType = IBufferByteAccess
    public typealias CStruct = CWinRT.IBufferByteAccess

    public static var iid: CWinRT.IID { CWinRT.IID_IBufferByteAccess }

    public static func toSwift(_ pointer: CPointer) -> SwiftType {
        // TODO: Check if the COM pointer is a wrapper
        return SwiftWrapper(pointer)
    }

    public static func toC(_ obj: SwiftType) -> CPointer {
        if let wrapper = obj as? SwiftWrapper { return wrapper.pointer }
        // TODO: Create a COM wrapper
        fatalError()
    }

    private final class SwiftWrapper: SwiftWrapperBase<CStruct>, IBufferByteAccessProtocol {
        func buffer() throws -> UnsafeMutablePointer<UInt8>! {
            var retval: UnsafeMutablePointer<UInt8>?
            try COMError.throwIfFailed(pointer.pointee.lpVtbl.pointee.Buffer(pointer, &retval))
            return retval
        }
    }
}