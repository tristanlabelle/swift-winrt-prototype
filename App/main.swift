import WinRT
import UWP_WindowsSecurityCryptographyCore
import UWP_WindowsStorageStreams

let windowsRuntime = try WindowsRuntimeScope(multithreaded: false)
let provider = try HashAlgorithmProvider.openAlgorithm("SHA256")!
let length = try provider.hashLength
let hash = try provider.createHash()!
let buffer = try hash.getValueAndReset()!
let bufferLength = try buffer.length;
let bufferByteAccess = try buffer.queryInterface(WindowsStorageStreams_IBufferByteAccessProjection.self)!
let pointer = try bufferByteAccess.buffer
print("")