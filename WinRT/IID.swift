import CWinRT

public typealias IID = CWinRT.IID

extension IID: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.Data1 == rhs.Data1 && lhs.Data2 == rhs.Data2 && lhs.Data3 == rhs.Data3
            && lhs.Data4.0 == rhs.Data4.0 && lhs.Data4.1 == rhs.Data4.1
            && lhs.Data4.2 == rhs.Data4.2 && lhs.Data4.3 == rhs.Data4.3
            && lhs.Data4.4 == rhs.Data4.4 && lhs.Data4.5 == rhs.Data4.5
            && lhs.Data4.6 == rhs.Data4.6 && lhs.Data4.7 == rhs.Data4.7
    }
}