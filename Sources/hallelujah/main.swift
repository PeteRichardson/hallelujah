// Plays a short "Hallelujah!" and quits. Run it at the end of long builds:
//
//     make; hallelujah

import AVFoundation
import MachO

/// Returns the sound that the linker embedded in the `__TEXT,__hallelujah` section.
func embeddedSound() -> Data? {
    var size: UInt = 0
    let header = #dsohandle.assumingMemoryBound(to: mach_header_64.self)
    guard let bytes = getsectiondata(header, "__TEXT", "__hallelujah", &size), size > 0 else {
        return nil
    }
    return Data(bytesNoCopy: bytes, count: Int(size), deallocator: .none)
}

guard let sound = embeddedSound() else {
    FileHandle.standardError.write(Data("hallelujah: no sound is embedded in this binary\n".utf8))
    exit(1)
}

do {
    let player = try AVAudioPlayer(data: sound)
    guard player.play() else {
        FileHandle.standardError.write(Data("hallelujah: cannot start playback\n".utf8))
        exit(1)
    }
    while player.isPlaying {
        RunLoop.main.run(until: .now + 0.05)
    }
} catch {
    FileHandle.standardError.write(Data("hallelujah: \(error.localizedDescription)\n".utf8))
    exit(1)
}
