import XCTest
import WindowsRuntime

internal class WinRTTestCase: XCTestCase {
    private static var winRTInit: Result<WinRTInitialization, any Error>?

    override class func setUp() {
        winRTInit = Result { try WinRTInitialization(multithreaded: false) }
    }

    override func setUpWithError() throws {
        try XCTSkipIf(Self.winRTInit?.get() == nil)
    }

    override class func tearDown() {
        winRTInit = nil
    }
}