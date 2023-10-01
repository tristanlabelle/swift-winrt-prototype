import XCTest
import UWP_WindowsSecurityCryptographyCore
import UWP_WindowsStorageStreams
import WinRT

internal final class RefCountTests: WinRTTestCase {
    func testAfterQueryInterfaceOfSwiftObject() throws {
        try XCTSkipIf(true, "queryInterface on COMExport is not implemented yet")
        let swiftObject = SwiftBuffer([1, 2, 3])
        XCTAssertEqual(COMObjectBase._getUnsafeRefCount(swiftObject), 0)
        let comObject = try swiftObject.queryInterface(IBufferProjection.self)
        XCTAssertEqual(COMObjectBase._getUnsafeRefCount(comObject), 1)
    }

    func testWinRTObject() throws {
        try XCTSkipIf(true, "HashAlgorithmProvider.openAlgorithm might be cached")
        let comObject = try HashAlgorithmProvider.openAlgorithm("SHA256")
        XCTAssertEqual(COMObjectBase._getUnsafeRefCount(comObject), 1)
    }
}