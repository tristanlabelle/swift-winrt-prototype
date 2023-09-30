import CWinRT

extension HSTRING {
    public static func allocate(_ value: String) throws -> HSTRING? {
        let chars = Array(value.utf16)
        return try chars.withUnsafeBufferPointer {
            var result: HSTRING?
            try COMError.throwIfFailed(CWinRT.WindowsCreateString($0.baseAddress!, UInt32(chars.count), &result))
            return result
        }
    }

    public static func deleteOrAssert(_ value: HSTRING?) {
        let hr = CWinRT.WindowsDeleteString(value)
        assert(COMError.isSuccess(hr), "Failed to delete HSTRING")
    }

    public static func toStringAndDelete(_ value: HSTRING?) -> String {
        let result = value.toString()
        deleteOrAssert(value)
        return result
    }
}

extension Optional where Wrapped == HSTRING {
    public func duplicate() throws -> Self {
        var result: HSTRING?
        try COMError.throwIfFailed(CWinRT.WindowsDuplicateString(self, &result))
        return result
    }

    public func toString() -> String {
        var length: UInt32 = 0
        guard let ptr = CWinRT.WindowsGetStringRawBuffer(self, &length) else { return "" }
        return String(utf16CodeUnits: ptr, count: Int(length))
    }
}
