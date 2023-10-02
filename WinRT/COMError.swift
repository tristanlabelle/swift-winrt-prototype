import CWinRT

public typealias HRESULT = CWinRT.HRESULT

public struct COMError: Error, Hashable {
    public static let fail = COMError(hr: HRESULT(bitPattern: 0x80004005))
    public static let invalidArg = COMError(hr: HRESULT(bitPattern: 0x80070057))
    public static let notImpl = COMError(hr: HRESULT(bitPattern: 0x80004001))
    public static let noInterface = COMError(hr: HRESULT(bitPattern: 0x80004002))
    public static let outOfMemory = COMError(hr: HRESULT(bitPattern: 0x8007000E))

    public var hr: HRESULT

    public var message: String? { Self.getMessage(hr) }

    public var description: String {
        if let message = self.message {
            return "HRESULT(0x\(String(hr, radix: 16, uppercase: true))): \(message)"
        }

        return "HRESULT(0x\(String(hr, radix: 16, uppercase: true)))"
    }

    public static func isSuccess(_ hr: HRESULT) -> Bool { hr >= 0 }
    public static func isFailure(_ hr: HRESULT) -> Bool { hr < 0 }

    public static func getMessage(_ hr: HRESULT) -> String? {
        let dwFlags: DWORD = DWORD(FORMAT_MESSAGE_ALLOCATE_BUFFER)
            | DWORD(FORMAT_MESSAGE_FROM_SYSTEM)
            | DWORD(FORMAT_MESSAGE_IGNORE_INSERTS)

        var buffer: UnsafeMutablePointer<WCHAR>? = nil
        // When specifying ALLOCATE_BUFFER, lpBuffer is used as an LPWSTR*
        let dwResult: DWORD = withUnsafeMutablePointer(to: &buffer) {
            $0.withMemoryRebound(to: WCHAR.self, capacity: 1) {
                CWinRT.FormatMessageW(
                    dwFlags,
                    /* lpSource: */ nil,
                    /* dwMessageId: */ DWORD(bitPattern: hr),
                    /* dwLanguageId: */ 0,
                    /* lpBuffer*/ $0,
                    /* nSize: */ 0,
                    /* Arguments: */ nil)
            }
        }
        guard let buffer else { return nil }
        defer { CWinRT.LocalFree(buffer) }
        guard dwResult > 0 else { return nil }

        return String(decodingCString: buffer, as: UTF16.self)
    }

    @discardableResult
    public static func throwIfFailed(_ hr: HRESULT) throws -> HRESULT {
        if isSuccess(hr) { return hr }
        throw COMError(hr: hr)
    }

    public static func `catch`(_ block: () throws -> Void) -> HRESULT {
        do {
            try block()
            return 0
        } catch let error as COMError {
            return error.hr
        } catch {
            return COMError.fail.hr
        }
    }
}