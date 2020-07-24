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
import Photos

class GIF {
    static let shared = GIF()
    let context = CIContext()
    
    // file input
    var movieURL: URL?
    
    // for image frames
    var frames: [UIImage] = []
    var frameDelay = 0.1
    var thumbnails: [UIImage] = []
    var trimStart: Int = -1
    var trimEnd: Int = -1
    
    // for image processing
    var originalFrameSize: CGSize = .zero
    var contextRect: CGRect = .zero
    var cropRectRatio: RectRatio = RectRatio()
//    let sepiaFilter = CIFilter(name: "CISepiaTone")
//    var sepiaIntensity = 1.0
    var overlays: [UIImage] = []
    
    // file output
    var gifURL: URL?
    
    private let thumbnailCount = 7
    
    init() {
        
    }
    
    func generateFrames() {
        print("generateFrames")
        
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
        let framerate = 15
        let totalTimeLength = Int(videoDuration.seconds * Double(videoDuration.timescale))
        let sampleCount = Int((videoDuration.seconds * Double(framerate)).rounded(.down))
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
                if self.contextRect != .zero {
                    var cropRect: CGRect = contextRect
                    
                    image = image.cropping(to: cropRect)!
                    
                }
                
//                // MARK: Image processing
//                var ciImage = self.sepiaFilter(CIImage(cgImage: image), intensity: self.sepiaIntensity)
//
//                if ciImage != nil {
//                    print("hi")
//                    image = self.convertCIImageToCGImage(inputImage: ciImage!)
//                }
                
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
    
    func calculateContextRect() {
        contextRect.size.width = CGFloat(self.originalFrameSize.width) * self.cropRectRatio.width
        contextRect.size.height = CGFloat(self.originalFrameSize.height) * self.cropRectRatio.height
        contextRect.origin.x = CGFloat(self.originalFrameSize.width) * self.cropRectRatio.originX
        contextRect.origin.y = CGFloat(self.originalFrameSize.height) * self.cropRectRatio.originY
    }
    
    func applyFilters() {
        for frameIndex in 0...self.frames.count - 1 {
//            print(self.frames[frameIndex])
//            var ciImage = self.sepiaFilter(CIImage(image: self.frames[frameIndex])!, intensity: self.sepiaIntensity)
//
//            if ciImage != nil {
//                print("hi")
//                self.frames[frameIndex] = UIImage(ciImage: ciImage!)
//            }
            
            let inputImage = CIImage(image: self.frames[frameIndex])!
            let parameters = [
                "inputSaturation": NSNumber(value: ToolbarSelections.shared.saturationAmount),
                "inputBrightness": NSNumber(value: ToolbarSelections.shared.brightnessAmount),
                "inputContrast": NSNumber(value: ToolbarSelections.shared.contrastAmount)
            ]
            let outputImage = inputImage.applyingFilter("CIColorControls", parameters: parameters)

            let context = CIContext(options: nil)
            self.frames[frameIndex] = UIImage(cgImage: context.createCGImage(outputImage, from: outputImage.extent)!)
//            return UIImage(cgImage: img)
        }
    }
    
    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage?
    {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    
//    func makeGIF(with images: [UIImage], fileName: String, frameDelay: Double) {
    func makeGIF(destinationFileName: String) {
        do {
            let destinationURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(destinationFileName) as NSURL
            let destinationGIF = CGImageDestinationCreateWithURL(destinationURL, kUTTypeGIF, self.frames.count, nil)!

            // This dictionary controls the delay between frames
            // If you don't specify this, CGImage will apply a default delay
            let properties = [
                (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): frameDelay]
            ]

            self.applyFilters()
            
            for textOverlay in ToolbarSelections.shared.textOverlays {
                let textImage = self.createTextImage(textOverlay: textOverlay)
                
                let size = self.frames[0].size
                let scale = self.frames[0].scale
                
                UIGraphicsBeginImageContextWithOptions(size, false, scale)
                
                for (i, image) in self.frames[0...self.frames.count-1].enumerated() {
//                    let cropRect: CGRect = .zero
//                    cropRect.size.width = CGFloat(image.width) * self.cropRectRatio.width
//                    cropRect.size.height = CGFloat(image.height) * self.cropRectRatio.height
//                    cropRect.origin.x = CGFloat(image.width) * self.cropRectRatio.originX
//                    cropRect.origin.y = CGFloat(image.height) * self.cropRectRatio.originY
                    
                    image.draw(in: CGRect(x: 0, y: 0, width: self.frames[0].size.width, height: self.frames[0].size.height))
//                    textImage?.draw(in: self.contextRect)
                    textImage?.draw(at: CGPoint(x: self.frames[0].size.width * textOverlay.rectRatio.originX, y: self.frames[0].size.height * textOverlay.rectRatio.originY))
                    
                    self.frames[i] = UIGraphicsGetImageFromCurrentImageContext() ?? self.frames[i]
                }
                
            }
            
            if self.trimStart == -1 {
                self.trimStart = 0
            }
            if self.trimEnd == -1 {
                self.trimEnd = self.frames.count-1
            }
            
            for img in self.frames[self.trimStart...self.trimEnd] {
                // Add the frame to the GIF image
                let ciImage = CIImage(image: img)
                let cgImage = self.convertCIImageToCGImage(inputImage: ciImage!)
                
                CGImageDestinationAddImage(destinationGIF, cgImage!, properties as CFDictionary)
            }

            // Write the GIF file to disk
            CGImageDestinationFinalize(destinationGIF)
            
//            guard let gif = UIImage(data: try Data(contentsOf: destinationURL as URL)) else { return }
//            self.writeToPhotoAlbum(image: gif)
            
            print(destinationURL)
            
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .photo, fileURL: destinationURL as URL, options: nil)
            }) { (success, error) in
                if let error = error {
                    print(error)
//                    completion(.failure(error))
                } else {
                    print(success)
//                    completion(.success(true))
                }
            }
        } catch {
            print(error)
        }
    }
    
    func createTextImage(textOverlay: TextOverlay?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: textOverlay!.width * 2, height: textOverlay!.height * 2)
//        let frame = contextRect
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .left
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = textOverlay?.color
        nameLabel.font = textOverlay?.font.withSize((textOverlay?.fontSize ?? 40) * 2)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = textOverlay?.text
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        if self.context != nil {
            return self.context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
}
