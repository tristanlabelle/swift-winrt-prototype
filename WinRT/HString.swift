import CWinRT

internal class HString {
    internal let value: CWinRT.HSTRING?

    init(consuming value: CWinRT.HSTRING?) {
        self.value = value
    }

    init(duplicating value: CWinRT.HSTRING?) {
        var result: CWinRT.HSTRING?
        CWinRT.WindowsDuplicateString(value, &result)
        self.value = result
    }

    init(_ value: String) {
        let chars = Array(value.utf16)
        self.value = chars.withUnsafeBufferPointer {
            var result: HSTRING?
            CWinRT.WindowsCreateString($0.baseAddress!, UInt32(chars.count), &result)
            return result
        }
    }

    var isEmpty: Bool { self.value == nil }

    func toString() -> String { Self.toString(self.value) }

    static func toString(_ value: CWinRT.HSTRING?) -> String {
        var length: UInt32 = 0
        let ptr = CWinRT.WindowsGetStringRawBuffer(value, &length)
        return String(utf16CodeUnits: ptr!, count: Int(length))
    }

    static func toString(consuming value: CWinRT.HSTRING?) -> String {
        defer { CWinRT.WindowsDeleteString(value) }
        return toString(value)
    }

    deinit {
        CWinRT.WindowsDeleteString(self.value)
    }
}
