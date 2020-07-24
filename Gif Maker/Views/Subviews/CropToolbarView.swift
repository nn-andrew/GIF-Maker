//
//  CropToolbarView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/14/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct CropToolbarView: View {
    let toolbar = ToolbarSelections.shared
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Button(action: {
                    self.toolbar.cropRatio = .free
                }) {
                    Text("Custom")
                }
                
                Button(action: {
                    self.toolbar.cropRatio = .r1x1
                }) {
                    Text("Square")
                }
                
                Button(action: {
                    self.toolbar.cropRatio = .r4x3
                }) {
                    Text("4:3")
                }
                
                Button(action: {
                    self.toolbar.cropRatio = .r3x2
                }) {
                    Text("3:2")
                }
                
                Button(action: {
                    self.toolbar.cropRatio = .r16x9
                }) {
                    Text("16:9")
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct CropToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        CropToolbarView()
    }
}
