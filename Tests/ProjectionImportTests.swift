import XCTest
import COM
import WindowsRuntime
import UWP_WindowsFoundation
import UWP_WindowsFoundationDiagnostics
import UWP_WindowsSecurityCryptographyCore
import UWP_WindowsStorageStreams

internal final class ProjectionImportTests: WinRTTestCase {
    func testActivationFactory() throws {
        let provider = try HashAlgorithmProvider.openAlgorithm("SHA256")
        XCTAssertEqual(try provider.hashLength, 32)
    }

    func testQueryCOMInterface() throws {
        let sha256OfEmpty: [UInt8] = [
            0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
            0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
            0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
            0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55 ]
        let buffer = try HashAlgorithmProvider.openAlgorithm("SHA256").createHash().getValueAndReset()
        let bufferByteAccess = try buffer.queryInterface(IBufferByteAccessProjection.self)
        let bufferPointer = try UnsafeMutableBufferPointer(start: bufferByteAccess.buffer, count: Int(buffer.length))
        XCTAssertEqual(Array(bufferPointer), sha256OfEmpty) 
    }

    func testAsyncMethodAndDelegates() throws {
        let asyncOperation = try ErrorDetails.createFromHResultAsync(HResult.fail)
        let asyncInfo = try asyncOperation.queryInterface(IAsyncInfoProjection.self)
        XCTAssertEqual(try asyncInfo.status, .started)
    }

    func testRefCountsThroughQueryInterface() throws {
        func getCOMRefCount(_ value: IUnknown) -> UInt32 {
            (value as? any COMProjection)?._unsafeRefCount ?? 0
        }

        // HashAlgorithmProvider instances from openAlgorithm could be cached, 
        // but it wouldn't make sense for IBuffer instances
        let buffer = try HashAlgorithmProvider.openAlgorithm("SHA256").createHash().getValueAndReset()
        XCTAssertEqual(getCOMRefCount(buffer), 1)

        do {
            // Assume that the different COM interfaces share the same refcount
            let bufferByteAccess = try buffer.queryInterface(IBufferByteAccessProjection.self)
            XCTAssertEqual(getCOMRefCount(buffer), 2)
            XCTAssertEqual(getCOMRefCount(bufferByteAccess), 2)
        }

        XCTAssertEqual(getCOMRefCount(buffer), 1)
    }
}