import XCTest
import UWP_WindowsSecurityCryptographyCore
import UWP_WindowsStorageStreams
import WinRT

internal final class RefCountTests: WinRTTestCase {
    func testAfterQueryInterfaceOfSwiftObject() throws {
        // CFGetRetainCount does not exist on Windows

        let swiftObject = SwiftBuffer([1, 2, 3])
        // XCTAssertEqual(CFGetRetainCount(swiftObject), 1)
        XCTAssertEqual(COMObjectBase._getUnsafeRefCount(swiftObject), 0)

        do {
            let comObject1 = try swiftObject.queryInterface(IBufferProjection.self)
            // XCTAssertEqual(CFGetRetainCount(swiftObject), 2)
            XCTAssertEqual(COMObjectBase._getUnsafeRefCount(comObject1), 1)

            do {
                let comObject2 = try swiftObject.queryInterface(IBufferByteAccessProjection.self)
                // XCTAssertEqual(CFGetRetainCount(swiftObject), 3)
                XCTAssertEqual(COMObjectBase._getUnsafeRefCount(comObject1), 1)
                XCTAssertEqual(COMObjectBase._getUnsafeRefCount(comObject2), 1)
            }

            // XCTAssertEqual(CFGetRetainCount(swiftObject), 2)
            XCTAssertEqual(COMObjectBase._getUnsafeRefCount(comObject1), 1)
        }

        // XCTAssertEqual(CFGetRetainCount(swiftObject), 1)
    }

    func testWinRTObject() throws {
        try XCTSkipIf(true, "HashAlgorithmProvider.openAlgorithm might be cached")
        let comObject = try HashAlgorithmProvider.openAlgorithm("SHA256")
        XCTAssertEqual(COMObjectBase._getUnsafeRefCount(comObject), 1)
    }
}