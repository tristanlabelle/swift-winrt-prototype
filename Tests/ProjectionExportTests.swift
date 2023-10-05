import XCTest
import UWP_WindowsSecurityCryptographyCore
import UWP_WindowsStorageStreams
import WindowsRuntime

internal final class ProjectionExportTests: WinRTTestCase {
    func testIUnknownIdentityRule() throws {
        let swiftBuffer = SwiftBuffer([1, 2, 3])
        let bufferByteAccess = try swiftBuffer.queryInterface(IBufferByteAccessProjection.self)
        let buffer = try swiftBuffer.queryInterface(IBufferProjection.self)
        XCTAssertEqual(
            try bufferByteAccess.queryInterface(IUnknownProjection.self)._unknown,
            try buffer.queryInterface(IUnknownProjection.self)._unknown)
    }

    func testTransitivityRule() throws {
        let swiftBuffer = SwiftBuffer([1, 2, 3])
        let unknown = try swiftBuffer.queryInterface(IUnknownProjection.self)
        let buffer = try swiftBuffer.queryInterface(IBufferProjection.self)
        let bufferByteAccess = try swiftBuffer.queryInterface(IBufferByteAccessProjection.self)

        // QueryInterface should succeed from/to any pair of implemented interfaces
        let objects: [COMObject] = [unknown, bufferByteAccess, buffer]
        for object in objects {
            _ = try object.queryInterface(IUnknownProjection.self)
            _ = try object.queryInterface(IBufferProjection.self)
            _ = try object.queryInterface(IBufferByteAccessProjection.self)
        }
    }
}