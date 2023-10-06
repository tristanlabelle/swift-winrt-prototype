import CWinRT

public enum HResultProjection: ABIInertProjection {
    public typealias SwiftType = HResult
    public typealias ABIType = CWinRT.HRESULT

    public static func toSwift(_ value: CWinRT.HRESULT) -> SwiftType { HResult(value) }
    public static func toABI(_ value: HResult) throws -> CWinRT.HRESULT { value.value }
}