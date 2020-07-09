//
//  GIF.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/8/20.
//  Copyright © 2020 six. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI
import MobileCoreServices

class GIF {
    var movieURL: URL?
    
    var frames: [UIImage] = []
    var frameDelay = 0.1
    
    var gifURL: URL?
    
    init() {
        
    }
    
    func makeGIF() {
        self.generateFrames()
        
        do {
            let name = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("user-gif.gif")
            self.convertFramesToGIF(with: self.frames, name: name as NSURL, frameDelay: self.frameDelay)
        } catch {
            print(error)
        }
    }
    
    private func generateFrames() {
        let asset = AVURLAsset(url: self.movieURL!, options: nil)
        let videoDuration = asset.duration
        
        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceAfter = .zero
        generator.requestedTimeToleranceBefore = .zero
        // https://developer.apple.com/forums/thread/66332

        var frameForTimes = [NSValue]()
        let sampleCounts = 20
        let totalTimeLength = Int(videoDuration.seconds * Double(videoDuration.timescale))
        let step = totalTimeLength / sampleCounts
      
        for i in 0 ..< sampleCounts {
            let cmTime = CMTimeMake(value: Int64(i * step), timescale: Int32(videoDuration.timescale))
            frameForTimes.append(NSValue(time: cmTime))
        }
      
        generator.generateCGImagesAsynchronously(forTimes: frameForTimes, completionHandler: {requestedTime, image, actualTime, result, error in
            DispatchQueue.main.async {
                if let image = image {
//                    print(requestedTime.value, requestedTime.seconds, actualTime.value)
                    self.frames.append(UIImage(cgImage: image))
                }
            }
        })
    }
    
    private func convertFramesToGIF(with images: [UIImage], name: NSURL, frameDelay: Double) {

        let destinationURL = name
        let destinationGIF = CGImageDestinationCreateWithURL(destinationURL, kUTTypeGIF, images.count, nil)!

        // This dictionary controls the delay between frames
        // If you don't specify this, CGImage will apply a default delay
        let properties = [
            (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): frameDelay]
        ]


        for img in images {
            // Add the frame to the GIF image
            var ciImage = CIImage(image: img)
            var cgImage = self.convertCIImageToCGImage(inputImage: ciImage!)
            
            CGImageDestinationAddImage(destinationGIF, cgImage!, properties as CFDictionary)
        }

        // Write the GIF file to disk
        CGImageDestinationFinalize(destinationGIF)
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
}
