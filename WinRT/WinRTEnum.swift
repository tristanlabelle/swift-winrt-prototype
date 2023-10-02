public protocol WinRTEnum: Hashable {
    associatedtype CEnum: RawRepresentable where CEnum.RawValue: FixedWidthInteger & Hashable
    var value: CEnum.RawValue { get }
    init(_ value: CEnum.RawValue)
}

extension WinRTEnum {
    public init(_ value: CEnum) { self.init(value.rawValue) }
}