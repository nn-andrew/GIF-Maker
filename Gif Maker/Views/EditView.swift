//
//  EditView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/9/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct EditView: View {
    
    @State var confirmChanges: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
//                Colors.gray6
//                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        self.trimView // * 0.95 originally
                            .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.08)
                            .clipped()
                            .border(Color.blue)
                        
                        ZStack {
                            self.framesView
                            
                            if self.isPresentingCropView {
                                VStack(spacing: 0) {
                                    CropView()
                                        .animation(.linear(duration: 0.12))
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.6, height: geo.size.height * 0.6)
                        .padding(30)
                        
                        ZStack {
                            GeometryReader { bottomGeo in
                                VStack(spacing: 0) {
                                    self.toolsView
                                    
                                    self.playButtonView
                                }
                                if self.isPresentingCropView {
                                    VStack(spacing: 0) {
                                        CropToolsView()
                                            .animation(.linear(duration: 0.12))
                                            .transition(.move(edge: .bottom))
    //                                        .frame(width: geo.size.width, height: geo.size.height)
                                        
                                        ConfirmationView(isPresentingView: self.$isPresentingCropView)
                                    }
                                }
                            }
                        }
                        .frame(width: geo.size.width, height: geo.size.height * 0.2)
                    
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
        }
        .navigationBarTitle(Text(""))
        .navigationBarHidden(true)
        .onAppear(perform: {
            self.trimEndFrameIndex = GIF.shared.frames.count-1
        })
    }
    
    
    // MARK: Trim View
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
                    ForEach(0..<GIF.shared.thumbnails.count) { i in
                        Image(uiImage: GIF.shared.thumbnails[i])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width / 7, height: geo.size.width / 7)
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
                                self.trimStartFrameIndex = Int(self.trimStartOffset.width) * (GIF.shared.frames.count-1) / Int(geo.size.width)
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
                                self.trimEndFrameIndex = (GIF.shared.frames.count-1) + Int(self.trimEndOffset.width) * (GIF.shared.frames.count-1) / Int(geo.size.width)
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
        ZStack {
            Colors.gray6
                .edgesIgnoringSafeArea(.all)
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
    }
    
    // MARK: Frames
    @State var frameIndex = 0
    @State var timer: Timer?
    @State var geoFramesView: GeometryProxy?
    var framesView: some View {
        // Frame to show in editor
        
        return GeometryReader { geo in
            VStack(spacing: 0) {
                Image(uiImage: GIF.shared.frames[self.frameIndex])
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear(perform: {
                self.geoFramesView = geo
                self.playFrames()
            })
        }
    }
    
    func playFrames() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: GIF.shared.frameDelay, repeats: true, block: { timer in
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
    @State var isPresentingCropView = false
    var toolsView: some View {
        GeometryReader { geo in
            ZStack {
                Colors.gray6
                    .edgesIgnoringSafeArea(.all)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            self.isPresentingCropView.toggle()
                        }) {
                            Text("Crop")
                        }
                    }
                }
                .scaledToFill()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
