
import CWinRT

public enum IUnknownProjection: COMProjection {
    public typealias SwiftType = IUnknown
    public typealias CStruct = CWinRT.IUnknown

    public static var iid: CWinRT.IID { CWinRT.IID_IUnknown }

    public static func toSwift(_ pointer: CPointer) -> SwiftType {
        return SwiftWrapperBase(pointer)
    }

    public static func toC(_ obj: SwiftType) -> CPointer { fatalError() }

    private final class COMWrapper {
        private let interface: UnsafeMutablePointer<Interface>
        let swiftObject: SwiftType

        init(_ obj: SwiftType) {
            swiftObject = obj
            interface = UnsafeMutablePointer<Interface>.allocate(capacity: 1)
            interface.pointee.vtable = withUnsafePointer(to: &Self.vtable) { $0 }
            interface.pointee.wrapper = Unmanaged.passRetained(self)
        }

        var pointer: CPointer {
            interface.withMemoryRebound(to: CStruct.self, capacity: 1) { $0 }
        }

        private struct Interface {
            var vtable: UnsafePointer<CWinRT.IUnknownVtbl>
            var wrapper: Unmanaged<COMWrapper>
        }

        private static func getSwiftObject<CStruct>(_ pointer: UnsafeMutablePointer<CStruct>) -> SwiftType {
            let interface = pointer.withMemoryRebound(to: Interface.self, capacity: 1) { $0 }
            let wrapper = interface.pointee.wrapper
            return wrapper.takeUnretainedValue().swiftObject
        }

        private static func catchHR(_ block: () throws -> Void) -> HRESULT {
            do {
                try block()
                return 0
            } catch let error as COMError {
                return error.hr
            } catch {
                return COMError.fail.hr
            }
        }

        private static var vtable: CWinRT.IUnknownVtbl = .init(
            QueryInterface: { this, iid, ppvObject in
                guard let this, let iid, let ppvObject else {
                    ppvObject?.pointee = nil
                    return COMError.invalidArg.hr
                }

                let swiftObject = getSwiftObject(this as UnsafeMutablePointer<CWinRT.IUnknown>)
                return catchHR {
                    guard let result = try swiftObject.queryInterface(iid.pointee) else {
                        ppvObject.pointee = nil
                        throw COMError.noInterface
                    }

                    fatalError()
                }
            },
            AddRef: { this in
                guard let this else { return 0 }
                let interface = this.withMemoryRebound(to: Interface.self, capacity: 1) { $0 }
                let wrapper = interface.pointee.wrapper
                wrapper.retain()
                return ULONG(_getRetainCount(wrapper.takeUnretainedValue()))
            },
            Release: { this in
                guard let this else { return 0 }
                let interface = this.withMemoryRebound(to: Interface.self, capacity: 1) { $0 }
                let wrapper = interface.pointee.wrapper
                wrapper.release()
                return ULONG(_getRetainCount(wrapper.takeUnretainedValue()))
            }
        )
    }
}