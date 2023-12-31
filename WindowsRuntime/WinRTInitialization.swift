import CWinRT

public final class WinRTInitialization {
    public init(multithreaded: Bool) throws {
        CWinRT.RoInitialize(multithreaded ? CWinRT.RO_INIT_MULTITHREADED  : CWinRT.RO_INIT_SINGLETHREADED)
    }

    deinit {
        CWinRT.RoUninitialize()
    }
}