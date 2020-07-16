//
//  CropView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/13/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct CropView2: View {
    
    @State var geoSize: CGSize = .zero
    var cropArea: some Shape {
        get {
//            return Rectangle()
//                .frame(width: geoSize.width + self.offsetTR.width - self.offsetTL.width,
//                       height: geoSize.height + self.offsetBL.height - self.offsetTL.height)
//                .offset(x: (self.offsetTR.width + self.offsetTL.width)/2,
//                        y: (self.offsetBL.height + self.offsetTL.height)/2)
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            print("hi")
//                        }
//                )
            
            var shape = Rectangle()
                .path(in: CGRect(x: 0, y: 0, width: geoSize.width, height: geoSize.height))
            shape.addPath(
                Rectangle().path(in: CGRect(x: self.areaOffset.width,
                                            y: self.areaOffset.height,
                                            width: self.areaSize.width,
                                            height: self.areaSize.height))
            )
//            print("\(self.areaOffset.width), \(self.areaOffset.height), \(self.areaSize.width), \(self.areaSize.height)")
            return shape
        }
    }
    
    @State var areaSize: CGSize = .zero
    @State var areaSizeSum: CGSize = .zero
    @State var areaOffset: CGSize = .zero
    @State var areaOffsetSum: CGSize = .zero
    
    
    @State var cropRectRatio: RectRatio = RectRatio()
    
    @State var cornerSize: CGFloat = 0
    
    @State var offsetTL = CGSize(width: 0, height: 0)
    @State var offsetTLAccumulate = CGSize(width: 0, height: 0)
    
    @State var offsetTR = CGSize(width: 0, height: 0)
    @State var offsetTRAccumulate = CGSize(width: 0, height: 0)

    @State var offsetBL = CGSize(width: 0, height: 0)
    @State var offsetBLAccumulate = CGSize(width: 0, height: 0)

    @State var offsetBR = CGSize(width: 0, height: 0)
    @State var offsetBRAccumulate = CGSize(width: 0, height: 0)
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .mask(self.cropArea.fill(style: FillStyle(eoFill: true)))
                    .opacity(0.8)
                
//                self.cropArea
                
                // Top Left
                Image("crop_corner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.cornerSize, height: self.cornerSize)
                    .position(x: 0, y: 0)
                    .offset(self.areaOffset)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.areaOffset.width = min(max(gesture.translation.width + self.areaOffsetSum.width, 0), geo.size.width)
                                self.areaOffset.height = min(max(gesture.translation.height + self.areaOffsetSum.height, 0), geo.size.height)
                                
                                self.areaSize.width = min(max(-gesture.translation.width + self.areaSizeSum.width, 0), geo.size.width)
                                self.areaSize.height = min(max(geo.size.height - (gesture.translation.height + self.areaOffsetSum.height), 0), geo.size.height)
                                print(self.areaSize.width)
                                
                                self.calculateRatio(geo: geo)
                            })
                            .onEnded({ gesture in
                                self.areaOffsetSum = self.areaOffset
                                
                                self.calculateRatio(geo: geo)
                            })
                    )
                
                // Top Right
                Image("crop_corner")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: self.cornerSize, height: self.cornerSize)
                    .offset(x: -geo.size.width + self.areaOffset.width + self.areaSize.width, y: self.areaOffset.height)
                    .position(x: geo.size.width, y: 0)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.areaOffset.height = min(max(gesture.translation.height + self.areaOffsetSum.height, 0), geo.size.height)
                                
                                self.areaSize.width = min(max(gesture.translation.width + self.areaSizeSum.width, 0), geo.size.width)
                                self.areaSize.height = min(max(geo.size.height - self.areaOffset.height, 0), geo.size.height)
                                
                                self.calculateRatio(geo: geo)
                            })
                            .onEnded({ gesture in
                                self.areaOffsetSum = self.areaOffset
                                self.areaSizeSum = self.areaSize
                                
                                self.calculateRatio(geo: geo)
                            })
                    )
                
                // Bottom Left
                Image("crop_corner")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: 270))
                    .frame(width: self.cornerSize, height: self.cornerSize)
                    .offset(self.offsetBL)
                    .position(x: 0, y: geo.size.height)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.offsetBL = CGSize(
                                    width: min(max(gesture.translation.width + self.offsetBLAccumulate.width, 0), geo.size.width),
                                    height: min(max(gesture.translation.height + self.offsetBLAccumulate.height, -geo.size.height), 0))
                                
                                self.offsetTL.width = self.offsetBL.width
                                self.offsetBR.height = self.offsetBL.height
                                
                                self.calculateRatio(geo: geo)
                            })
                            .onEnded({ gesture in
                                self.offsetBL = CGSize(
                                    width: min(max(gesture.translation.width + self.offsetBLAccumulate.width, 0), geo.size.width),
                                    height: min(max(gesture.translation.height + self.offsetBLAccumulate.height, -geo.size.height), 0))
                                
                                self.offsetTL.width = self.offsetBL.width
                                self.offsetBR.height = self.offsetBL.height
                                
                                self.offsetBLAccumulate = self.offsetBL
                                self.offsetTLAccumulate.width = self.offsetBL.width
                                self.offsetBRAccumulate.height = self.offsetBL.height
                                
                                self.calculateRatio(geo: geo)
                            })
                    )
                
                // Bottom Right
                Image("crop_corner")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: 180))
                    .frame(width: self.cornerSize, height: self.cornerSize)
                    .offset(self.offsetBR)
                    .position(x: geo.size.width, y: geo.size.height)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.offsetBR = CGSize(
                                    width: min(max(gesture.translation.width + self.offsetBRAccumulate.width, -geo.size.width), 0),
                                    height: min(max(gesture.translation.height + self.offsetBRAccumulate.height, -geo.size.height), 0))
                                
                                self.offsetBL.height = self.offsetBR.height
                                self.offsetTR.width = self.offsetBR.width
                                
                                self.calculateRatio(geo: geo)
                            })
                            .onEnded({ gesture in
                                self.offsetBR = CGSize(
                                    width: min(max(gesture.translation.width + self.offsetBRAccumulate.width, -geo.size.width), 0),
                                    height: min(max(gesture.translation.height + self.offsetBRAccumulate.height, -geo.size.height), 0))
                                
                                self.offsetBL.height = self.offsetBR.height
                                self.offsetTR.width = self.offsetBR.width
                                
                                self.offsetBRAccumulate = self.offsetBR
                                self.offsetTRAccumulate.width = self.offsetTR.width
                                self.offsetBLAccumulate.height = self.offsetBL.height
                                
                                self.calculateRatio(geo: geo)
                            })
                    )
            }
            .onAppear(perform: {
                self.geoSize = geo.size
                self.cornerSize = geo.size.height * 0.05
                
                self.areaSize = geo.size
            })
        }
    }
    
    func calculateRatio(geo: GeometryProxy) {
        self.cropRectRatio.width = (geo.size.width + self.offsetTR.width - self.offsetTL.width) / geo.size.width
        self.cropRectRatio.height = (geo.size.height + self.offsetBL.height - self.offsetTL.height) / geo.size.height
        self.cropRectRatio.originX = self.offsetTL.width / geo.size.width
        self.cropRectRatio.originY = self.offsetTL.height / geo.size.height
//        self.cropRectRatio.originX = ((geo.size.width + self.offsetTR.width - self.offsetTL.width / 2)) / geo.size.width
//        self.cropRectRatio.originY = ((geo.size.height + self.offsetBL.height - self.offsetTL.height / 2)) / geo.size.height
        
//        self.cropRect.size.width /= GIF.shared.frames[0].size.width
//        self.cropRect.size.height /= GIF.shared.frames[0].size.height
//        self.cropRect.origin.x /= GIF.shared.frames[0].size.width
//        self.cropRect.origin.y /= GIF.shared.frames[0].size.height
        
        GIF.shared.cropRectRatio = self.cropRectRatio
        print(GIF.shared.cropRectRatio)
    }
}

//struct RectRatio {
//    var width: CGFloat = 0
//    var height: CGFloat = 0
//    var originX: CGFloat = 0
//    var originY: CGFloat = 0
//}

//struct CropView_Previews: PreviewProvider {
//    static var previews: some View {
//        CropView()
//    }
//}
