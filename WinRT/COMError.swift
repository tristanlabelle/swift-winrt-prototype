import CWinRT

public struct COMError: Error {
    public static let fail = COMError(hr: HRESULT(bitPattern: 0x80004005))
    public static let invalidArg = COMError(hr: HRESULT(bitPattern: 0x80070057))
    public static let noInterface = COMError(hr: HRESULT(bitPattern: 0x80004002))

    var hr: HRESULT

    @discardableResult
    public static func throwIfFailed(_ hr: HRESULT) throws -> HRESULT {
        if hr >= 0 { return hr }
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