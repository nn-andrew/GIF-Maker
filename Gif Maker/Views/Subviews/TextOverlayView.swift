//
//  TextOverlayView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/19/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct TextOverlayView: View {
    @ObservedObject var toolbar = ToolbarSelections.shared
    
    @State var geoSize: CGSize = .zero
    var cropArea: some Shape {
        get {
            
            var shape = Rectangle().path(in: CGRect(x: 0, y: 0, width: geoSize.width, height: geoSize.height))
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
    
    @State var textOverlay: TextOverlay = TextOverlay()
    @State var textOverlayRectRatio: RectRatio = RectRatio()
    @State var text: String = ToolbarSelections.shared.currentTextOverlay?.text ?? ""
    var font: UIFont = ToolbarSelections.shared.currentTextOverlay?.font ?? UIFont.systemFont(ofSize: 40)
//    var font: UIFont = ToolbarSelections.shared.currentTextOverlay?.font ?? UIFont.systemFont(ofSize: 40)
    var fontSize: CGFloat = ToolbarSelections.shared.currentTextOverlay?.fontSize ?? 40
//    var fontSize: CGFloat = ToolbarSelections.shared.currentTextOverlay?.fontSize ?? 40
    var textColor: UIColor = ToolbarSelections.shared.currentTextOverlay?.color ?? .white
//    var textColor: UIColor = ToolbarSelections.shared.currentTextOverlay?.color ?? .white
    
    @State var isNewTextOverlay: Bool = true
    
    let cornerSize: CGFloat = 80
    
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
                    .fill(Color.clear)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .mask(
                        self.cropArea
                            .fill(style: FillStyle(eoFill: true))
                    )
//                    .opacity(0.2)
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
                                
                                self.calculateRatio(geo: geo)
                                self.calculateFontSize(geo: geo)
                            }
                        .onEnded() { gesture in
                            self.offsetTLAccumulate = self.offsetTL
                            self.offsetTRAccumulate = self.offsetTR
                            self.offsetBLAccumulate = self.offsetBL
                            self.offsetBRAccumulate = self.offsetBR
                        }
                    )
                
                TextView(textOverlay: self.$textOverlay, text: self.$text, font: self.font, color: self.textColor, fontSize: self.fontSize)
                    .frame(
                        width: geo.size.width + self.offsetTR.width - self.offsetTL.width,
                        height: geo.size.height + self.offsetBL.height - self.offsetTL.height
                    )
                    .offset(x: (self.offsetTL.width + self.offsetTR.width) / 2, y: (self.offsetTL.height + self.offsetBL.height) / 2)
//                    .font(.system(size: (geo.size.width + self.offsetTR.width - self.offsetTL.width) * 0.2))
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
                                
                                self.calculateRatio(geo: geo)
                                self.calculateFontSize(geo: geo)
                            }
                            .onEnded() { gesture in
                                self.offsetTLAccumulate = self.offsetTL
                                self.offsetTRAccumulate = self.offsetTR
                                self.offsetBLAccumulate = self.offsetBL
                                self.offsetBRAccumulate = self.offsetBR
                                
                                self.assignOffsetsToObject()
                                self.assignOffsetAccumulatesToObject()
                                self.textOverlay.width = self.textOverlayRectRatio.width * geo.size.width
                                self.textOverlay.height = self.textOverlayRectRatio.height * geo.size.height
                            }
                )
                
                // Top Left
                self.cropCorner
                    .position(x: 0, y: 0)
//                    .position(self.toolbar.cropRatio == .r1x1 ? CGPoint(x: 100, y: 100) : .zero)
                    .offset(self.offsetTL)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                self.offsetTL = CGSize(
                                    width: min(max(gesture.translation.width + self.offsetTLAccumulate.width, 0), geo.size.width + self.offsetTR.width - 30),
                                    height: min(max(gesture.translation.height + self.offsetTLAccumulate.height, 0), geo.size.height + self.offsetBL.height - 30))
                                
                                self.offsetTR.height = self.offsetTL.height
                                self.offsetBL.width = self.offsetTL.width
                                
                                self.calculateRatio(geo: geo)
                                self.calculateFontSize(geo: geo)
                            })
                            .onEnded({ gesture in
                                
                                self.offsetTLAccumulate = self.offsetTL
                                self.offsetTRAccumulate.height = self.offsetTL.height
                                self.offsetBLAccumulate.width = self.offsetTL.width
                                
                                self.assignOffsetsToObject()
                                self.assignOffsetAccumulatesToObject()
                                self.textOverlay.width = self.textOverlayRectRatio.width * geo.size.width
                                self.textOverlay.height = self.textOverlayRectRatio.height * geo.size.height
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
                                
                                self.calculateRatio(geo: geo)
                                self.calculateFontSize(geo: geo)
                            })
                            .onEnded({ gesture in
                                
                                self.offsetTRAccumulate = self.offsetTR
                                self.offsetTLAccumulate.height = self.offsetTR.height
                                self.offsetBRAccumulate.width = self.offsetTR.width
                                
                                self.assignOffsetsToObject()
                                self.assignOffsetAccumulatesToObject()
                                self.textOverlay.width = self.textOverlayRectRatio.width * geo.size.width
                                self.textOverlay.height = self.textOverlayRectRatio.height * geo.size.height
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
                                
                                self.calculateRatio(geo: geo)
                                self.calculateFontSize(geo: geo)
                            })
                            .onEnded({ gesture in
                                
                                self.offsetBLAccumulate = self.offsetBL
                                self.offsetTLAccumulate.width = self.offsetBL.width
                                self.offsetBRAccumulate.height = self.offsetBL.height
                                
                                self.assignOffsetsToObject()
                                self.assignOffsetAccumulatesToObject()
                                self.textOverlay.width = self.textOverlayRectRatio.width * geo.size.width
                                self.textOverlay.height = self.textOverlayRectRatio.height * geo.size.height
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
                                
                                self.calculateRatio(geo: geo)
                                self.calculateFontSize(geo: geo)
                            })
                            .onEnded({ gesture in
                                
                                self.offsetBRAccumulate = self.offsetBR
                                self.offsetTRAccumulate.width = self.offsetTR.width
                                self.offsetBLAccumulate.height = self.offsetBL.height
                                
                                self.assignOffsetsToObject()
                                self.assignOffsetAccumulatesToObject()
                                self.textOverlay.width = self.textOverlayRectRatio.width * geo.size.width
                                self.textOverlay.height = self.textOverlayRectRatio.height * geo.size.height
                            })
                    )
            }
            .onAppear(perform: {
                self.geoSize = geo.size
                self.calculateRatio(geo: geo)
                self.calculateFontSize(geo: geo)
                
                if self.toolbar.textOverlays.first(where: {$0.id == self.textOverlay.id}) == nil {
                    self.toolbar.currentTextOverlay = self.textOverlay
                } else {
                    self.text = self.textOverlay.text
                    self.assignOffsetsToSelf()
                    self.assignOffsetAccumulatesToSelf()
                    
                    self.calculateRatio(geo: geo)
                    self.calculateFontSize(geo: geo)
                    self.isNewTextOverlay = false
                    
                    self.toolbar.currentTextOverlay = nil
                }
            })
        }
    }
    
    func calculateRatio(geo: GeometryProxy) {
        self.textOverlayRectRatio.width = (geo.size.width + self.offsetTR.width - self.offsetTL.width) / geo.size.width
        self.textOverlayRectRatio.height = (geo.size.height + self.offsetBL.height - self.offsetTL.height) / geo.size.height
        self.textOverlayRectRatio.originX = self.offsetTL.width / geo.size.width
        self.textOverlayRectRatio.originY = self.offsetTL.height / geo.size.height
        
        self.textOverlay.rectRatio = self.textOverlayRectRatio
    }
    
    func calculateFontSize(geo: GeometryProxy) {
        self.textOverlay.fontSize = (geo.size.width + self.offsetTR.width - self.offsetTL.width) * 0.2
    }
    
    func assignOffsetsToObject() {
        self.textOverlay.offsetTL = self.offsetTL.self
        self.textOverlay.offsetTR = self.offsetTR.self
        self.textOverlay.offsetBL = self.offsetBL.self
        self.textOverlay.offsetBR = self.offsetBR.self
    }
    
    func assignOffsetsToSelf() {
        self.offsetTL = self.textOverlay.offsetTL
        self.offsetTR = self.textOverlay.offsetTR
        self.offsetBL = self.textOverlay.offsetBL
        self.offsetBR = self.textOverlay.offsetBR
    }
    
    func assignOffsetAccumulatesToObject() {
        self.textOverlay.offsetTLAccumulate = self.offsetTLAccumulate.self
        self.textOverlay.offsetTRAccumulate = self.offsetTRAccumulate.self
        self.textOverlay.offsetBLAccumulate = self.offsetBLAccumulate.self
        self.textOverlay.offsetBRAccumulate = self.offsetBRAccumulate.self
    }
    
    func assignOffsetAccumulatesToSelf() {
        self.offsetTLAccumulate = self.textOverlay.offsetTLAccumulate
        self.offsetTRAccumulate = self.textOverlay.offsetTRAccumulate
        self.offsetBLAccumulate = self.textOverlay.offsetBLAccumulate
        self.offsetBRAccumulate = self.textOverlay.offsetBRAccumulate
    }
    
    var cropCorner: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .opacity(0.005)
                .frame(width: self.cornerSize, height: self.cornerSize)
            Rectangle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
                .mask(
                    Image("crop_corner")
                        .resizable()
                        .scaledToFit()
                )
                .opacity(self.isNewTextOverlay ? 1.0 : 0.4)
        }
    }
}

//struct TextOverlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextOverlayView()
//    }
//}
