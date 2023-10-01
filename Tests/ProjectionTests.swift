import XCTest
import UWP_WindowsSecurityCryptographyCore
import UWP_WindowsStorageStreams
import WinRT

internal final class ProjectionTests: WinRTTestCase {
    func testActivationFactory() throws {
        let provider = try HashAlgorithmProvider.openAlgorithm("SHA256")!
        XCTAssertEqual(try provider.hashLength, 32)
    }

    func testQueryCOMInterface() throws {
        let sha256OfEmpty: [UInt8] = [
            0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
            0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
            0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
            0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55 ]
        let buffer = try HashAlgorithmProvider.openAlgorithm("SHA256").createHash().getValueAndReset()!
        let bufferByteAccess = try buffer.queryInterface(IBufferByteAccessProjection.self)!
        let bufferPointer = try UnsafeMutableBufferPointer(start: bufferByteAccess.buffer, count: Int(buffer.length))
        XCTAssertEqual(Array(bufferPointer), sha256OfEmpty) 
    }
}