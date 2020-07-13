//
//  EditView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/9/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct EditView: View {
    
    @Binding var gif: GIF
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    self.trimView
                        .frame(width: geo.size.width * 0.95, height: geo.size.height * 0.08)
                        .border(Color.blue)
                    
                    self.framesView
                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.4)

                    self.toolsView
                    
                    self.playButtonView
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .navigationBarTitle(Text(""))
        .navigationBarHidden(true)
        .onAppear(perform: {
            self.trimEndFrameIndex = self.gif.frames.count-1
        })
    }
    
    @State var trimStartOffset = CGSize(width: 0, height: 0)
    @State var trimStartOffsetAccumulate = CGSize(width: 0, height: 0)
    @State var trimEndOffset = CGSize(width: 0, height: 0)
    @State var trimEndOffsetAccumulate = CGSize(width: 0, height: 0)
    
    @State var trimStartFrameIndex = 0
    @State var trimEndFrameIndex = 0
    var trimView: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 0) {
                    ForEach(0..<self.gif.thumbnails.count) { i in
                        Image(uiImage: self.gif.thumbnails[i])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.height, height: geo.size.height)
                            .clipped()
                    }
                }
                
                // MARK: Trim
                ZStack {
                    // trimStart
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.black)
                            .opacity(0.6)
                            .frame(width: geo.size.width, height: geo.size.height)
                        RoundedRectangle(cornerRadius: 18)
                            .frame(width: geo.size.width * 0.015, height: geo.size.height)
                    }
                    .offset(x: self.trimStartOffset.width, y: 0)
                    .position(x: geo.size.width * 0.01 - geo.size.width / 2, y: geo.frame(in: .local).origin.y + geo.size.height * 0.5)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.trimStartOffset.width = min(max(gesture.translation.width + self.trimStartOffsetAccumulate.width, 0), geo.size.width * 0.95 + self.trimEndOffset.width)
                                
                                self.pauseFrames()
                                self.trimStartFrameIndex = Int(self.trimStartOffset.width) * self.gif.frames.count / Int(geo.size.width)
                                self.frameIndex = self.trimStartFrameIndex
                            }
                            .onEnded { gesture in
                                self.trimStartOffset.width = min(max(gesture.translation.width + self.trimStartOffsetAccumulate.width, 0.0), geo.size.width * 0.95 + self.trimEndOffset.width)
                                self.trimStartOffsetAccumulate = self.trimStartOffset
                                
                                if self.isPlaying {
                                    self.playFrames()
                                }
                            }
                    )
                    
                    // trimEnd
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 18)
                            .frame(width: geo.size.width * 0.015, height: geo.size.height)
                        Rectangle()
                            .fill(Color.black)
                            .opacity(0.6)
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .offset(x: self.trimEndOffset.width, y: 0)
                    .position(x: geo.size.width * 0.99 + geo.size.width / 2, y: geo.frame(in: .local).origin.y + geo.size.height * 0.5)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.trimEndOffset.width = min(max(gesture.translation.width + self.trimEndOffsetAccumulate.width, -geo.size.width * 0.95 + self.trimStartOffset.width), 0)
                                
                                self.pauseFrames()
                                self.trimEndFrameIndex = self.gif.frames.count + Int(self.trimEndOffset.width) * self.gif.frames.count / Int(geo.size.width)
                                self.frameIndex = self.trimEndFrameIndex
                            }
                            .onEnded { gesture in
                                self.trimEndOffset.width = min(max(gesture.translation.width + self.trimEndOffsetAccumulate.width, -geo.size.width * 0.95 + self.trimStartOffset.width), 0)
                                self.trimEndOffsetAccumulate = self.trimEndOffset
                                
                                if self.isPlaying {
                                    self.frameIndex = self.trimStartFrameIndex
                                    self.playFrames()
                                }
                            }
                    )
                    
                    
                }
//                RSlider(lowerValue: self.$trimStart, upperValue: self.$trimEnd, minimumValue: 0, maximumValue: Double(self.gif.frames.count-1))
                    
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear(perform: {
//                self.trimEndOffset.width = geo.size.width * 0.95
//                self.trimEnd = Double(self.gif.frames.count)
            })
        }
    }
    
    // MARK: Play Button
    @State var isPlaying = true
    var playButtonView: some View {
        Button(action: {
            self.isPlaying.toggle()
            if self.isPlaying {
                self.playFrames()
            } else {
                self.pauseFrames()
            }
        }) {
            Text(self.isPlaying ? "Pause" : "Play")
        }
    }
    
    // MARK: Frames
    @State var frameIndex = 0
    @State var timer: Timer?
    var framesView: some View {
        // Frame to show in editor
        
        return VStack {
            Image(uiImage: self.gif.frames[min(self.frameIndex, self.gif.frames.count-1)])
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: {
            self.playFrames()
        })
    }
    
    func playFrames() {
//        self.frameIndex = 0
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: self.gif.frameDelay, repeats: true, block: { timer in
            if self.frameIndex >= self.trimEndFrameIndex {
                self.frameIndex = self.trimStartFrameIndex
            } else {
                self.frameIndex = (self.frameIndex + 1)
            }
        })
    }
    
    func pauseFrames() {
        self.timer?.invalidate()
    }
    
    
    // MARK: Tools Menu
    @State var presentCropView = false
    var toolsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button(action: {
                    self.presentCropView = true
                }) {
                    Text("Crop")
                }
            }
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
