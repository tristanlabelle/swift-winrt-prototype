import WinRT

let windowsRuntime = try WindowsRuntimeScope(multithreaded: false)
let provider = try HashAlgorithmProvider.openAlgorithm("SHA256")!
let length = try provider.hashLength
let hash = try provider.createHash()!
let buffer = try hash.getValueAndReset()!
let bufferLength = try emptyBuffer.length;
print("")