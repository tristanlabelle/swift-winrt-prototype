import XCTest
import COM
import WindowsRuntime
import UWP_WindowsSecurityCryptographyCore
import UWP_WindowsStorageStreams

internal final class ProjectionExportTests: WinRTTestCase {
    func testIUnknownIdentityRule() throws {
        let swiftBuffer = SwiftBuffer([1, 2, 3])
        let bufferByteAccess = try swiftBuffer.queryInterface(IBufferByteAccessProjection.self)
        let buffer = try swiftBuffer.queryInterface(IBufferProjection.self)
        XCTAssertEqual(
            try bufferByteAccess.queryInterface(IUnknownProjection.self)._unknown,
            try buffer.queryInterface(IUnknownProjection.self)._unknown)
    }

    func testIInspectableIdentityRule() throws {
        let swiftBuffer = SwiftBuffer([1, 2, 3])
        let bufferByteAccess = try swiftBuffer.queryInterface(IBufferByteAccessProjection.self)
        let buffer = try swiftBuffer.queryInterface(IBufferProjection.self)
        XCTAssertEqual(
            try bufferByteAccess.queryInterface(IUnknownProjection.self)._unknown,
            try buffer.queryInterface(IInspectableProjection.self)._unknown)
    }

    func testQueryInterfaceTransitivityRule() throws {
        let swiftBuffer = SwiftBuffer([1, 2, 3])
        let unknown = try swiftBuffer.queryInterface(IUnknownProjection.self)
        let inspectable = try swiftBuffer.queryInterface(IInspectableProjection.self)
        let buffer = try swiftBuffer.queryInterface(IBufferProjection.self)
        let bufferByteAccess = try swiftBuffer.queryInterface(IBufferByteAccessProjection.self)

        // QueryInterface should succeed from/to any pair of implemented interfaces
        let objects: [any IUnknownProtocol] = [unknown, inspectable, bufferByteAccess, buffer]
        for object in objects {
            _ = try object.queryInterface(IUnknownProjection.self)
            _ = try object.queryInterface(IInspectableProjection.self)
            _ = try object.queryInterface(IBufferProjection.self)
            _ = try object.queryInterface(IBufferByteAccessProjection.self)
        }
    }
}