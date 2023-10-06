import CWinRT

public enum HResultProjection: ABIInertProjection {
    public typealias SwiftValue = HResult
    public typealias ABIValue = CWinRT.HRESULT

    public static func toSwift(_ value: CWinRT.HRESULT) -> SwiftValue { HResult(value) }
    public static func toABI(_ value: HResult) throws -> CWinRT.HRESULT { value.value }
}