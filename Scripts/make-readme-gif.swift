import AVFoundation
import Foundation
import ImageIO
import UniformTypeIdentifiers

guard CommandLine.arguments.count == 3 else {
    fputs("Usage: swift Scripts/make-readme-gif.swift input.mp4 output.gif\n", stderr)
    exit(2)
}

let inputURL = URL(fileURLWithPath: CommandLine.arguments[1])
let outputURL = URL(fileURLWithPath: CommandLine.arguments[2])
let asset = AVURLAsset(url: inputURL)
let duration = CMTimeGetSeconds(asset.duration)
let framesPerSecond = 8.0
let frameCount = max(1, Int(duration * framesPerSecond))

guard duration.isFinite, duration > 0 else {
    fputs("Could not read the video duration.\n", stderr)
    exit(1)
}

guard let destination = CGImageDestinationCreateWithURL(
    outputURL as CFURL,
    UTType.gif.identifier as CFString,
    frameCount,
    nil
) else {
    fputs("Could not create the GIF destination.\n", stderr)
    exit(1)
}

CGImageDestinationSetProperties(
    destination,
    [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]] as CFDictionary
)

let generator = AVAssetImageGenerator(asset: asset)
generator.appliesPreferredTrackTransform = true
generator.maximumSize = CGSize(width: 320, height: 720)
generator.requestedTimeToleranceBefore = CMTime(seconds: 0.03, preferredTimescale: 600)
generator.requestedTimeToleranceAfter = CMTime(seconds: 0.03, preferredTimescale: 600)

let frameProperties = [
    kCGImagePropertyGIFDictionary: [
        kCGImagePropertyGIFDelayTime: 1 / framesPerSecond,
        kCGImagePropertyGIFUnclampedDelayTime: 1 / framesPerSecond,
    ],
] as CFDictionary

for index in 0..<frameCount {
    let time = CMTime(
        seconds: Double(index) / framesPerSecond,
        preferredTimescale: 600
    )

    do {
        let frame = try generator.copyCGImage(at: time, actualTime: nil)
        CGImageDestinationAddImage(destination, frame, frameProperties)
    } catch {
        fputs("Skipping frame \(index): \(error)\n", stderr)
    }
}

guard CGImageDestinationFinalize(destination) else {
    fputs("Could not finalize the GIF.\n", stderr)
    exit(1)
}

print("Created \(outputURL.path) from \(String(format: "%.2f", duration)) seconds of video.")
