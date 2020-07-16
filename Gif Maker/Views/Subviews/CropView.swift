//
//  CropView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/13/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct CropView: View {
    
    @State var geoSize: CGSize = .zero
    var cropArea: some Shape {
        get {
            
            var shape = Rectangle()
                .path(in: CGRect(x: 0, y: 0, width: geoSize.width, height: geoSize.height))
            shape.addPath(
                Rectangle()
                    .path(in: CGRect(x: self.offsetTL.width,
                                     y: self.offsetTL.height,
                                     width: geoSize.width + self.offsetTR.width - self.offsetTL.width,
                                     height: geoSize.height + self.offsetBL.height - self.offsetTL.height))
            )
            return shape
        }
    }
    
    @State var cropRectRatio: RectRatio = RectRatio()
    
    let cornerSize: CGFloat = 80
    
    @State var offsetTL = CGSize(width: 0, height: 0)
    @State var offsetTLAccumulate = CGSize(width: 0, height: 0)
    
    @State var offsetTR = CGSize(width: 0, height: 0)
    @State var offsetTRAccumulate = CGSize(width: 0, height: 0)

    @State var offsetBL = CGSize(width: 0, height: 0)
    @State var offsetBLAccumulate = CGSize(width: 0, height: 0)

    @State var offsetBR = CGSize(width: 0, height: 0)
    @State var offsetBRAccumulate = CGSize(width: 0, height: 0)
    
    var lastAcceptableDrag: CGSize = .zero
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .mask(
                        self.cropArea
                            .fill(style: FillStyle(eoFill: true))
                    )
                    .opacity(0.8)
                    .gesture(
                        DragGesture()
                            .onChanged() { gesture in                                
                                if gesture.translation.width < 0 {
                                    self.offsetTL.width = min(max(gesture.translation.width + self.offsetTLAccumulate.width, 0), geo.size.width)
                                    self.offsetBL.width = min(max(gesture.translation.width + self.offsetBLAccumulate.width, 0), geo.size.width)
                                    
                                    if self.offsetTL.width > 0 {
                                        self.offsetTR.width = min(max(gesture.translation.width + self.offsetTRAccumulate.width, -geo.size.width), 0)
                                        self.offsetBR.width = min(max(gesture.translation.width + self.offsetBRAccumulate.width, -geo.size.width), 0)
                                    }
                                } else {
                                    
                                    self.offsetTR.width = min(max(gesture.translation.width + self.offsetTRAccumulate.width, -geo.size.width), 0)
                                    self.offsetBR.width = min(max(gesture.translation.width + self.offsetBRAccumulate.width, -geo.size.width), 0)
                                    
                                    if self.offsetTR.width < 0 {
                                        self.offsetTL.width = min(max(gesture.translation.width + self.offsetTLAccumulate.width, 0), geo.size.width)
                                        self.offsetBL.width = min(max(gesture.translation.width + self.offsetBLAccumulate.width, 0), geo.size.width)
                                    }
                                }
                                
                                if gesture.translation.height < 0 {
                                    self.offsetTL.height = min(max(gesture.translation.height + self.offsetTLAccumulate.height, 0), geo.size.height)
                                    self.offsetTR.height = min(max(gesture.translation.height + self.offsetTRAccumulate.height, 0), geo.size.height)
                                    
                                    if self.offsetTL.height > 0 {
                                        self.offsetBL.height = min(max(gesture.translation.height + self.offsetBLAccumulate.height, -geo.size.height), 0)
                                        self.offsetBR.height = min(max(gesture.translation.height + self.offsetBRAccumulate.height, -geo.size.height), 0)
                                    }
                                } else {
                                    self.offsetBL.height = min(max(gesture.translation.height + self.offsetBLAccumulate.height, -geo.size.height), 0)
                                    self.offsetBR.height = min(max(gesture.translation.height + self.offsetBRAccumulate.height, -geo.size.height), 0)
                                    
                                    if self.offsetBL.height < 0 {
                                        self.offsetTL.height = min(max(gesture.translation.height + self.offsetTLAccumulate.height, 0), geo.size.height)
                                        self.offsetTR.height = min(max(gesture.translation.height + self.offsetTRAccumulate.height, 0), geo.size.height)
                                    }
                                }
                                
                                
//                                self.offsetTL = CGSize(
//                                    width: min(max(gesture.translation.width + self.offsetTLAccumulate.width, 0), geo.size.width),
//                                    height: min(max(gesture.translation.height + self.offsetTLAccumulate.height, 0), geo.size.height))
//
//                                self.offsetTR = CGSize(
//                                    width: min(max(gesture.translation.width + self.offsetTRAccumulate.width, -geo.size.width), 0),
//                                    height: min(max(gesture.translation.height + self.offsetTRAccumulate.height, 0), geo.size.height))
//
//                                self.offsetBL = CGSize(
//                                    width: min(max(gesture.translation.width + self.offsetBLAccumulate.width, 0), geo.size.width),
//                                    height: min(max(gesture.translation.height + self.offsetBLAccumulate.height, -geo.size.height), 0))
//
//                                self.offsetBR = CGSize(
//                                    width: min(max(gesture.translation.width + self.offsetBRAccumulate.width, -geo.size.width), 0),
//                                    height: min(max(gesture.translation.height + self.offsetBRAccumulate.height, -geo.size.height), 0))
                                
                                self.calculateCrop(geo: geo)
                            }
                        .onEnded() { gesture in
                            self.offsetTLAccumulate = self.offsetTL
                            self.offsetTRAccumulate = self.offsetTR
                            self.offsetBLAccumulate = self.offsetBL
                            self.offsetBRAccumulate = self.offsetBR
                        }
                    )
                
                
//                self.cropArea
                
                // Top Left
                self.cropCorner
                    .position(x: 0, y: 0)
                    .offset(self.offsetTL)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.offsetTL = CGSize(
                                    width: min(max(gesture.translation.width + self.offsetTLAccumulate.width, 0), geo.size.width + self.offsetTR.width - 30),
                                    height: min(max(gesture.translation.height + self.offsetTLAccumulate.height, 0), geo.size.height + self.offsetBL.height - 30))
                                
                                self.offsetTR.height = self.offsetTL.height
                                self.offsetBL.width = self.offsetTL.width
                                
                                self.calculateCrop(geo: geo)
                            })
                            .onEnded({ gesture in
                                
                                self.offsetTLAccumulate = self.offsetTL
                                self.offsetTRAccumulate.height = self.offsetTL.height
                                self.offsetBLAccumulate.width = self.offsetTL.width
                                
                            })
                    )
                
                // Top Right
                self.cropCorner
                    .rotationEffect(Angle(degrees: 90))
                    .offset(self.offsetTR)
                    .position(x: geo.size.width, y: 0)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.offsetTR = CGSize(
                                    width: min(max(gesture.translation.width + self.offsetTRAccumulate.width, -geo.size.width + self.offsetTL.width + 30), 0),
                                    height: min(max(gesture.translation.height + self.offsetTRAccumulate.height, 0), geo.size.height + self.offsetBL.height - 30))
                                
                                self.offsetTL.height = self.offsetTR.height
                                self.offsetBR.width = self.offsetTR.width
                                
                                self.calculateCrop(geo: geo)
                            })
                            .onEnded({ gesture in
                                
                                self.offsetTRAccumulate = self.offsetTR
                                self.offsetTLAccumulate.height = self.offsetTR.height
                                self.offsetBRAccumulate.width = self.offsetTR.width
                                
                            })
                    )
                
                // Bottom Left
                self.cropCorner
                    .rotationEffect(Angle(degrees: 270))
                    .offset(self.offsetBL)
                    .position(x: 0, y: geo.size.height)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.offsetBL = CGSize(
                                    width: min(max(gesture.translation.width + self.offsetBLAccumulate.width, 0), geo.size.width + self.offsetTR.width - 30),
                                    height: min(max(gesture.translation.height + self.offsetBLAccumulate.height, -geo.size.height + self.offsetTL.height + 30), 0))
                                
                                self.offsetTL.width = self.offsetBL.width
                                self.offsetBR.height = self.offsetBL.height
                                
                                self.calculateCrop(geo: geo)
                            })
                            .onEnded({ gesture in
                                
                                self.offsetBLAccumulate = self.offsetBL
                                self.offsetTLAccumulate.width = self.offsetBL.width
                                self.offsetBRAccumulate.height = self.offsetBL.height
                                
                            })
                    )
                
                // Bottom Right
                self.cropCorner
                    .rotationEffect(Angle(degrees: 180))
                    .offset(self.offsetBR)
                    .position(x: geo.size.width, y: geo.size.height)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.offsetBR = CGSize(
                                    width: min(max(gesture.translation.width + self.offsetBRAccumulate.width, -geo.size.width + self.offsetTL.width + 30), 0),
                                    height: min(max(gesture.translation.height + self.offsetBRAccumulate.height, -geo.size.height + self.offsetTL.height + 30), 0))
                                
                                self.offsetBL.height = self.offsetBR.height
                                self.offsetTR.width = self.offsetBR.width
                                
                                self.calculateCrop(geo: geo)
                            })
                            .onEnded({ gesture in
                                
                                self.offsetBRAccumulate = self.offsetBR
                                self.offsetTRAccumulate.width = self.offsetTR.width
                                self.offsetBLAccumulate.height = self.offsetBL.height
                                
                            })
                    )
            }
            .onAppear(perform: {
                self.geoSize = geo.size
//                self.cornerSize = geo.size.height * 0.05
            })
        }
    }
    
    func calculateCrop(geo: GeometryProxy) {
        self.cropRectRatio.width = (geo.size.width + self.offsetTR.width - self.offsetTL.width) / geo.size.width
        self.cropRectRatio.height = (geo.size.height + self.offsetBL.height - self.offsetTL.height) / geo.size.height
        self.cropRectRatio.originX = self.offsetTL.width / geo.size.width
        self.cropRectRatio.originY = self.offsetTL.height / geo.size.height
        
        GIF.shared.cropRectRatio = self.cropRectRatio
//        print(GIF.shared.cropRectRatio)
    }
    
    var cropCorner: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .opacity(0.005)
                .frame(width: self.cornerSize, height: self.cornerSize)
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 20, height: 20)
                .mask(
                    Image("crop_corner")
                        .resizable()
                        .scaledToFit()
                )
        }
//        .border(Color.blue)
    }
}

struct RectRatio {
    var width: CGFloat = 0
    var height: CGFloat = 0
    var originX: CGFloat = 0
    var originY: CGFloat = 0
}

//struct CropView_Previews: PreviewProvider {
//    static var previews: some View {
//        CropView()
//    }
//}
