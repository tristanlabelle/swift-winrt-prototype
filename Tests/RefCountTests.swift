import XCTest
import UWP_WindowsSecurityCryptographyCore
import UWP_WindowsStorageStreams
import WinRT

internal final class RefCountTests: WinRTTestCase {
    func testQueryInterfaceOfSwiftObject() throws {
        let swiftBuffer = SwiftBuffer([1, 2, 3])
        XCTAssertEqual(COMObject._getUnsafeRefCount(swiftBuffer), 0)

        do {
            let buffer = try swiftBuffer.queryInterface(IBufferProjection.self)
            XCTAssertEqual(COMObject._getUnsafeRefCount(buffer), 1)

            do {
                let bufferByteAccess = try swiftBuffer.queryInterface(IBufferByteAccessProjection.self)
                XCTAssertEqual(COMObject._getUnsafeRefCount(buffer), 1)
                XCTAssertEqual(COMObject._getUnsafeRefCount(bufferByteAccess), 1)
            }

            XCTAssertEqual(COMObject._getUnsafeRefCount(buffer), 1)
        }
    }

    func testQueryInterfaceOfWinRTObject() throws {
        // HashAlgorithmProvider instances from openAlgorithm could be cached, 
        // but it wouldn't make sense for IBuffer instances
        let buffer = try HashAlgorithmProvider.openAlgorithm("SHA256").createHash().getValueAndReset()
        XCTAssertEqual(COMObject._getUnsafeRefCount(buffer), 1)

        do {
            // Assume that the different COM interfaces share the same refcount
            let bufferByteAccess = try buffer.queryInterface(IBufferByteAccessProjection.self)
            XCTAssertEqual(COMObject._getUnsafeRefCount(buffer), 2)
            XCTAssertEqual(COMObject._getUnsafeRefCount(bufferByteAccess), 2)
        }

        XCTAssertEqual(COMObject._getUnsafeRefCount(buffer), 1)
    }
}