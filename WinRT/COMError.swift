import CWinRT

public struct COMError: Error {
    public static let fail = COMError(hr: HRESULT(bitPattern: 0x80004005))
    public static let invalidArg = COMError(hr: HRESULT(bitPattern: 0x80070057))
    public static let noInterface = COMError(hr: HRESULT(bitPattern: 0x80004002))
    public static let outOfMemory = COMError(hr: HRESULT(bitPattern: 0x8007000E))

    var hr: HRESULT

    public static func isSuccess(_ hr: HRESULT) -> Bool { hr >= 0 }
    public static func isFailure(_ hr: HRESULT) -> Bool { hr < 0 }

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