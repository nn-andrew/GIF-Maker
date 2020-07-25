//
//  TextOverlayToolbarView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/19/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct TextOverlayToolbarView: View {
    var toolbar = ToolbarSelections.shared
    
    @State var currentFont: TextFont = .montserrat
    @State var currentColor: Color = .white
    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        Button(action: {
                            self.currentColor = .white
                            self.toolbar.currentTextOverlay?.color = .white
                        }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(self.currentColor == .white ? Colors.primary : .clear)
                                .frame(width: geo.size.width * 0.1, height: 30)
                                .overlay(
                                    GeometryReader { geo in
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                        .padding(2)
                                    }
                                )
                        }
                        
                        Button(action: {
                            self.currentColor = .black
                            self.toolbar.currentTextOverlay?.color = .black
                        }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(self.currentColor == .black ? Colors.primary : .clear)
                                .frame(width: geo.size.width * 0.1, height: 30)
                                .overlay(
                                    GeometryReader { geo in
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black)
                                        .padding(2)
                                    }
                                )
                        }
                        
                        Button(action: {
                            self.currentColor = .red
                            self.toolbar.currentTextOverlay?.color = .red
                        }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(self.currentColor == .red ? Colors.primary : .clear)
                                .frame(width: geo.size.width * 0.1, height: 30)
                                .overlay(
                                    GeometryReader { geo in
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.red)
                                        .padding(2)
                                    }
                                )
                        }
                        
                        Button(action: {
                            self.currentColor = .yellow
                            self.toolbar.currentTextOverlay?.color = .yellow
                        }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(self.currentColor == .yellow ? Colors.primary : .clear)
                                .frame(width: geo.size.width * 0.1, height: 30)
                                .overlay(
                                    GeometryReader { geo in
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.yellow)
                                        .padding(2)
                                    }
                                )
                        }
                        
                        Button(action: {
                            self.currentColor = .blue
                            self.toolbar.currentTextOverlay?.color = .blue
                        }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(self.currentColor == .blue ? Colors.primary : .clear)
                                .frame(width: geo.size.width * 0.1, height: 30)
                                .overlay(
                                    GeometryReader { geo in
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue)
                                        .padding(2)
                                    }
                                )
                        }
                        
                        Button(action: {
                            self.currentColor = .green
                            self.toolbar.currentTextOverlay?.color = .green
                        }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(self.currentColor == .green ? Colors.primary : .clear)
                                .frame(width: geo.size.width * 0.1, height: 30)
                                .overlay(
                                    GeometryReader { geo in
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.green)
                                        .padding(2)
                                    }
                                )
                        }
                        
                        Button(action: {
                            self.currentColor = .purple
                            self.toolbar.currentTextOverlay?.color = .purple
                        }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(self.currentColor == .purple ? Colors.primary : .clear)
                                .frame(width: geo.size.width * 0.1, height: 30)
                                .overlay(
                                    GeometryReader { geo in
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.purple)
                                        .padding(2)
                                    }
                                )
                        }
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        Button(action: {
                            self.toolbar.currentTextOverlay?.font = UIFont(name: "Montserrat-Bold", size: self.toolbar.currentTextOverlay?.fontSize ?? 12)!
                            self.currentFont = .montserrat
                        }) {
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(self.currentFont == .montserrat ? Colors.primary : Color.clear)
                                        .frame(width: 64, height: 64)
                                    FontImage(fontName: "Montserrat-Bold")
                                }
                                    
                                Text("Montserrat")
                                    .foregroundColor(Colors.primary)
                                    .font(.system(size: 14))
                            }
                            .frame(minWidth: 60)
                        }
                        
                        Button(action: {
                            self.toolbar.currentTextOverlay?.font = UIFont(name: "Rubik-Bold", size: self.toolbar.currentTextOverlay?.fontSize ?? 12)!
                            self.currentFont = .rubik
                        }) {
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(self.currentFont == .rubik ? Colors.primary : Color.clear)
                                        .frame(width: 64, height: 64)
                                    FontImage(fontName: "Rubik-Bold")
                                }
                                    
                                Text("Rubik")
                                    .foregroundColor(Colors.primary)
                                    .font(.system(size: 14))
                            }
                            .frame(minWidth: 60)
                        }
                        
                        Button(action: {
                            self.toolbar.currentTextOverlay?.font = UIFont(name: "Roboto-Bold", size: self.toolbar.currentTextOverlay?.fontSize ?? 12)!
                            self.currentFont = .roboto
                        }) {
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(self.currentFont == .roboto ? Colors.primary : Color.clear)
                                        .frame(width: 64, height: 64)
                                    FontImage(fontName: "Roboto-Bold")
                                }
                                    
                                Text("Roboto")
                                    .foregroundColor(Colors.primary)
                                    .font(.system(size: 14))
                            }
                            .frame(minWidth: 60)
                        }
                        
                        Button(action: {
                            self.toolbar.currentTextOverlay?.font = UIFont(name: "Caveat-Regular", size: self.toolbar.currentTextOverlay?.fontSize ?? 12)!
                            self.currentFont = .caveat
                        }) {
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(self.currentFont == .caveat ? Colors.primary : Color.clear)
                                        .frame(width: 64, height: 64)
                                    FontImage(fontName: "Caveat-Regular")
                                }
                                    
                                Text("Caveat")
                                    .foregroundColor(Colors.primary)
                                    .font(.system(size: 14))
                            }
                            .frame(minWidth: 60)
                        }
                    }
                }
                .scaledToFill()
//                .frame(height: geo.size.height)
            }
            .frame(height: geo.size.height)
        }
    }
}

struct FontImage: View {
    var fontName: String
    var body: some View {
        
        Text("Abc")
            .font(Font.custom(self.fontName, size: 20))
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .background(
                Circle()
                    .fill(Color.black)
            )
            .clipped()
            .mask(
                Circle()
                    .frame(width: 60, height: 60)
            )
    }
}

struct TextOverlayToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        TextOverlayToolbarView()
    }
}
