import CWinRT
import COM

public enum HStringProjection: ABIProjection {
    public typealias SwiftType = String
    public typealias ABIType = CWinRT.HSTRING?

    public static func toSwift(consuming value: CWinRT.HSTRING?) -> SwiftType { CWinRT.HSTRING.toStringAndDelete(value) }
    public static func toSwift(copying value: CWinRT.HSTRING?) -> SwiftType { value.toString() }
    public static func toABI(_ value: String) throws -> CWinRT.HSTRING? { try CWinRT.HSTRING.create(value) }
    public static func release(_ value: CWinRT.HSTRING?) { CWinRT.HSTRING.delete(value) }
}