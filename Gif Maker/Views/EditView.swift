//
//  EditView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/9/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

enum Menu {
    case main
    case crop
    case adjustment
    case textOverlay
    case speed
}

struct EditView: View {
    
    @State var currentMenu: Menu = .main
    @State var pushFinishedView: Bool = false
    
//    @State var confirmChanges: Bool = false
    var body: some View {
//        NavigationView {
        ZStack {
//                Colors.gray6
//                    .edgesIgnoringSafeArea(.all)
            GeometryReader { geo in
                VStack(spacing: 20) {
                    if self.currentMenu != .adjustment {
                        self.trimView
                            .frame(width: geo.size.width * 0.85, height: geo.size.width * 0.85 / 7)
                            .clipped()
                    }
                    
                    HStack {
                        
                        self.previewView
                            .frame(maxWidth: geo.size.width * 0.8, maxHeight: geo.size.height * 0.8)
                        
//                        if self.currentMenu == .crop {
//                            CropView()
////                                    .animation(.easeIn(duration: 0.5))
////                                    .transition(.opacity)
//                        }
//                        else if self.currentMenu == .adjustment {
//                            AdjustmentView()
//                                .animation(.easeIn(duration: 0.12))
//                                .transition(.opacity)
//                        }
//                        else if self.currentMenu == .textOverlay {
//                            TextOverlayView()
//                        }
//                        else {
//                            ForEach(ToolbarSelections.shared.textOverlays, id: \.id) { textOverlay in
//                                TextOverlayView(textOverlay: textOverlay,
//                                                text: textOverlay.text)
//
//                            }
//                        }
                    }
//                    .frame(width: self.geoPreviewView?.size.width, height: self.geoPreviewView?.size.height)
//                        .frame(width: geo.size.width * 0.6, height: geo.size.height * 0.7)
                    
                    HStack {
                        
                        ZStack {
                            
                            GeometryReader { toolbarGeo in
                                VStack(spacing: 0) {
                                    self.toolsView
                                        .frame(height: toolbarGeo.size.height * 0.4)
                                    
                                    GeometryReader { lowerToolbarGeo in
                                        ZStack {
                                            HStack {
                                                
                                                Spacer()
                                                
                                                self.continueButton
                                            }
                                            .padding([.leading, .trailing], 30)
                                            
                                            self.playButtonView
                                                .position(x: toolbarGeo.size.width * 0.5, y: lowerToolbarGeo.size.height * 0.5)
                                        }
                                    }
                                    .frame(width: toolbarGeo.size.width)
                                    
                                    Spacer()
                                }
                                .frame(height: toolbarGeo.size.height * 0.8)

                                if self.currentMenu != .main {
                                    Rectangle()
                                        .fill(Colors.gray6)
                                        .frame(width: geo.size.width)
                                }
                                
                                if self.currentMenu == .crop {
                                    VStack(spacing: 0) {
    //                                        CropToolbarView()
    //                                            .frame(height: toolbarGeo.size.height / 3)
                                        
                                        Rectangle()
                                            .fill(Colors.gray6)
                                        
                                        ConfirmationView(currentMenu: self.$currentMenu)
                                        
                                        Spacer()
                                    }
                                    .frame(height: toolbarGeo.size.height * 0.8)
                                    .padding([.leading, .trailing], 30)
                                    .animation(.easeInOut(duration: 0.12))
                                    .transition(.move(edge: .bottom))
                                }
                                else if self.currentMenu == .adjustment {
                                    VStack(spacing: 0) {
                                        AdjustmentToolbarView(saturationAmount: self.$saturationAmount,
                                            brightnessAmount: self.$brightnessAmount,
                                            contrastAmount: self.$contrastAmount)
                                            .frame(height: toolbarGeo.size.height * 0.6)
                                        Spacer()
                                        ConfirmationView(currentMenu: self.$currentMenu)
                                    }
                                    .frame(height: toolbarGeo.size.height * 0.8)
                                    .padding([.leading, .trailing], 30)
                                    .animation(.easeInOut(duration: 0.12))
                                    .transition(.move(edge: .bottom))
                                }
                                else if self.currentMenu == .textOverlay {
                                    VStack(spacing: 0) {
                                        TextOverlayToolbarView()
                                            .frame(height: toolbarGeo.size.height * 0.6)
                                        Spacer()
                                        ConfirmationView(currentMenu: self.$currentMenu)
                                    }
                                    .frame(height: toolbarGeo.size.height * 0.8)
                                    .padding([.leading, .trailing], 30)
                                    .animation(.easeInOut(duration: 0.12))
                                    .transition(.move(edge: .bottom))
                                }
//                                else if self.currentMenu == .speed {
//                                    VStack(spacing: 0) {
//                                        
//                                        SpeedToolbarView()
//                                        
//                                        ConfirmationView(currentMenu: self.$currentMenu)
//                                        
//                                        Spacer()
//                                    }
//                                    .frame(height: toolbarGeo.size.height * 0.8)
//                                    .padding([.leading, .trailing], 30)
//                                    .animation(.easeInOut(duration: 0.12))
//                                    .transition(.move(edge: .bottom))
//                                }
                            }
                            .padding(.top, 10)
//                            .padding([.leading, .trailing], 20)
                        }
                        .background(
                            Rectangle()
                                .fill(Colors.gray6)
                                .frame(width: geo.size.width)
                        )
                        .frame(width: geo.size.width)
                        .frame(height: self.currentMenu != .main && self.currentMenu != .crop ? geo.size.height * 0.3 : geo.size.height * 0.2)
                        
                        
                    }
                    
//                        Spacer()
                
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            
            if self.pushFinishedView {
                FinishedView(showFinishedView: self.$pushFinishedView)
                    .transition(.move(edge: .trailing))
            }
        }
//        }
//        .navigationBarTitle(Text(""))
//        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
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
                    ZStack {
                        GeometryReader { scrubberGeo in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Colors.primary)
                                .frame(width: scrubberGeo.size.width, height: scrubberGeo.size.height)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: scrubberGeo.size.width * 0.2, height: scrubberGeo.size.height * 0.6)
                                .position(x: scrubberGeo.size.width/2, y: scrubberGeo.size.height/2)
                        }
                        .frame(width: geo.size.width * 0.04, height: geo.size.height)
                    }
                }
                .offset(x: self.trimStartOffset.width, y: 0)
                .position(x: geo.size.width * 0.02 - geo.size.width / 2, y: geo.frame(in: .local).origin.y + geo.size.height * 0.5)
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
                            
                            GIF.shared.trimStart = self.trimStartFrameIndex
                            
                            if self.isPlaying {
                                self.playFrames()
                            }
                        }
                )
                
                // trimEnd
                HStack(spacing: 0) {
                    ZStack {
                        GeometryReader { scrubberGeo in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Colors.primary)
                                .frame(width: scrubberGeo.size.width, height: scrubberGeo.size.height)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: scrubberGeo.size.width * 0.2, height: scrubberGeo.size.height * 0.6)
                                .position(x: scrubberGeo.size.width/2, y: scrubberGeo.size.height/2)
                        }
                        .frame(width: geo.size.width * 0.04, height: geo.size.height)
                    }
                    Rectangle()
                        .fill(Color.black)
                        .opacity(0.6)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                .offset(x: self.trimEndOffset.width, y: 0)
                .position(x: geo.size.width * 0.98 + geo.size.width / 2, y: geo.frame(in: .local).origin.y + geo.size.height * 0.5)
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
                            
                            GIF.shared.trimEnd = self.trimEndFrameIndex
                            
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
//        Colors.gray6
//            .edgesIgnoringSafeArea(.all)
        Button(action: {
            self.isPlaying.toggle()
            if self.isPlaying {
                self.playFrames()
            } else {
                self.pauseFrames()
            }
        }) {
//                Text(self.isPlaying ? "Pause" : "Play")
            Rectangle()
                .fill(Colors.primary)
                .frame(width: 26, height: 26)
                .mask(
                    Image(self.isPlaying ? "pause_button" : "play_button")
                        .resizable()
                        .scaledToFit()
                )
        }
    }
}

var continueButton: some View {
    Button(action: {
//        GIF.shared.generateFrames()
        GIF.shared.makeGIF(destinationFileName: "user-gif.gif")
        print(ToolbarSelections.shared.brightnessAmount)
        
        self.pushFinishedView = true
    }) {
        Text("Done")
            .foregroundColor(Color.white)
            .padding(10)
            .background(Colors.primary)
            .cornerRadius(10)
    }
}

// MARK: Frames
@State var frameIndex = 0
@State var timer: Timer?
//@State var geoPreviewView: GeometryProxy?

@State var saturationAmount: Double = 1.0
@State var brightnessAmount: Double = 0.0
@State var contrastAmount: Double = 1.0
var previewView: some View {
    // Frame to show in editor
    
    return GeometryReader { geo in
        ZStack {
            Image(uiImage: GIF.shared.frames[self.frameIndex])
                .resizable()
                .scaledToFit()
                .saturation(self.saturationAmount)
                .brightness(self.brightnessAmount)
                .contrast(self.contrastAmount)
            
            if self.currentMenu == .crop {
                CropView()
//                                    .animation(.easeIn(duration: 0.5))
//                                    .transition(.opacity)
            }
            else if self.currentMenu == .adjustment {
                AdjustmentView()
                    .animation(.easeIn(duration: 0.12))
                    .transition(.opacity)
            }
            else if self.currentMenu == .textOverlay {
                TextOverlayView()
            }
            else {
                ForEach(ToolbarSelections.shared.textOverlays, id: \.id) { textOverlay in
                    TextOverlayView(textOverlay: textOverlay,
                                    text: textOverlay.text,
                                    font: textOverlay.font,
                                    fontSize: textOverlay.fontSize,
                                    textColor: textOverlay.color)
                }
            }
        }
//        .frame(width: geo.size.width, height: geo.size.height)
        .onAppear(perform: {
//            self.geoPreviewView = geo
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
var toolsView: some View {
    GeometryReader { geo in
        ZStack {
//            Color.red
//                .edgesIgnoringSafeArea(.bottom)
//                .frame(width: geo.size.width)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Button(action: {
                        self.currentMenu = .crop
                    }) {
                        VStack(spacing: 4) {
                            Rectangle()
                                .fill(Colors.primary)
                                .frame(width: 36, height: 36)
                                .mask(
                                    Image("crop_tool")
                                        .resizable()
                                        .scaledToFit()
                                )
                            
                            Text("Crop")
                                .foregroundColor(Colors.primary)
                                .font(.system(size: 12))
                        }
                        .frame(width: 70)
                        
                    }
                    
                    Button(action: {
                        self.currentMenu = .adjustment
                    }) {
                        VStack(spacing: 4) {
                            Rectangle()
                                .fill(Colors.primary)
                                .frame(width: 36, height: 36)
                                .mask(
                                    Image("adjustment_tool")
                                        .resizable()
                                        .scaledToFit()
                                )
                            
                            Text("Adjustment")
                                .foregroundColor(Colors.primary)
                                .font(.system(size: 12))
                        }
                        .frame(width: 70)
                    }
                    
                    Button(action: {
                            self.currentMenu = .textOverlay
                        }) {
                            VStack(spacing: 4) {
                                Rectangle()
                                    .fill(Colors.primary)
                                    .frame(width: 36, height: 36)
                                    .mask(
                                        Image("text_overlay_tool")
                                            .resizable()
                                            .scaledToFit()
                                    )
                                
                                Text("Text")
                                    .foregroundColor(Colors.primary)
                                    .font(.system(size: 12))
                            }
                            .frame(width: 70)
                        }
                    
//                    Button(action: {
//                            self.currentMenu = .speed
//                        }) {
//                            VStack(spacing: 4) {
//                                Rectangle()
//                                    .fill(Colors.primary)
//                                    .frame(width: 36, height: 36)
//                                    .mask(
//                                        Image("speed_tool")
//                                            .resizable()
//                                            .scaledToFit()
//                                    )
//
//                                Text("Speed")
//                                    .foregroundColor(Colors.primary)
//                                    .font(.system(size: 12))
//                            }
//                            .frame(width: 70)
//                        }
                    }
                }
                .padding([.leading, .trailing], 20)
            }
            .scaledToFill()
        }
    }
}


struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
