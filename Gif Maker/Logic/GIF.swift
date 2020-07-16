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
    static let shared = GIF()
    
    var movieURL: URL?
    
    var frames: [UIImage] = []
    var frameDelay = 0.1
    var thumbnails: [UIImage] = []
    
    var cropRectRatio: RectRatio?
    
    var gifURL: URL?
    
    private let thumbnailCount = 7
    
    init() {
        
    }
    
    func generateFrames() {
        self.frames = []
        self.thumbnails = []
        
        let asset = AVURLAsset(url: self.movieURL!, options: nil)
        let videoDuration = asset.duration
        
        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceAfter = .zero
        generator.requestedTimeToleranceBefore = .zero
        generator.appliesPreferredTrackTransform = true
        // https://developer.apple.com/forums/thread/66332

        var frameForTimes = [NSValue]()
        let totalTimeLength = Int(videoDuration.seconds * Double(videoDuration.timescale))
        let sampleCount = Int((videoDuration.seconds * 15).rounded(.down))
        let step = totalTimeLength / sampleCount
        self.frameDelay = videoDuration.seconds / Double(sampleCount)
      
        for i in 0 ..< sampleCount {
            let cmTime = CMTimeMake(value: Int64(i * step), timescale: Int32(videoDuration.timescale))
            frameForTimes.append(NSValue(time: cmTime))
        }
        
        // MARK: Generate images and add to frames array
        for frame in frameForTimes {
            do {
                var image = try generator.copyCGImage(at: frame as! CMTime, actualTime: nil)
                if self.cropRectRatio != nil {
                    var cropRect: CGRect = .zero
                    cropRect.size.width = CGFloat(image.width) * self.cropRectRatio!.width
                    cropRect.size.height = CGFloat(image.height) * self.cropRectRatio!.height
                    cropRect.origin.x = CGFloat(image.width) * self.cropRectRatio!.originX
                    cropRect.origin.y = CGFloat(image.height) * self.cropRectRatio!.originY
                    
                    image = image.cropping(to: cropRect)!
                }
                self.frames.append(UIImage(cgImage: image))
            } catch {
                print(error)
            }
        }
        
        // MARK: Populate thumbnail array with some frames
        let thumbnailStep = self.frames.count / self.thumbnailCount
        for i in 0..<self.thumbnailCount {
            self.thumbnails.append(self.frames[i * thumbnailStep])
        }
      
//        generator.generateCGImagesAsynchronously(forTimes: frameForTimes, completionHandler: {requestedTime, image, actualTime, result, error in
//            DispatchQueue.main.async {
//                if let image = image {
//                    self.frames.append(UIImage(cgImage: image))
//                }
//            }
//        })
    }
    
//    func makeGIF(with images: [UIImage], fileName: String, frameDelay: Double) {
    func makeGIF(fileName: String) {
        do {
            let destinationURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(fileName) as NSURL
            let destinationGIF = CGImageDestinationCreateWithURL(destinationURL, kUTTypeGIF, self.frames.count, nil)!

            // This dictionary controls the delay between frames
            // If you don't specify this, CGImage will apply a default delay
            let properties = [
                (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): frameDelay]
            ]


            for img in self.frames {
                // Add the frame to the GIF image
                var ciImage = CIImage(image: img)
                var cgImage = self.convertCIImageToCGImage(inputImage: ciImage!)
                
                CGImageDestinationAddImage(destinationGIF, cgImage!, properties as CFDictionary)
            }

            // Write the GIF file to disk
            CGImageDestinationFinalize(destinationGIF)
        } catch {
            print(error)
        }
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
}
