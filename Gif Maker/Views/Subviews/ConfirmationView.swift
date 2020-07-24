//
//  ConfirmationView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/14/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct ConfirmationView: View {
    let toolbar = ToolbarSelections.shared
    
    @Binding var currentMenu: Menu
    var body: some View {
        HStack {
            Button(action: {
                self.currentMenu = .main
                
                self.toolbar.saturationAmount = 1.0
                self.toolbar.brightnessAmount = 0.0
                self.toolbar.contrastAmount = 1.0
            }) {
                    Rectangle()
                        .fill(Colors.primary)
                        .frame(width: 20, height: 20)
                        .mask(
                            Image("cancel_button")
                                .resizable()
                                .scaledToFit()
                        )
            }
            
            Spacer()
            
            Button(action: {
                if self.currentMenu == .textOverlay && self.toolbar.currentTextOverlay != nil {
                    self.toolbar.textOverlays.append(self.toolbar.currentTextOverlay!)
//                    self.toolbar.currentTextOverlay = nil
                }
                
                self.currentMenu = .main
                
                GIF.shared.generateFrames()
                GIF.shared.calculateContextRect()
            }) {
                Rectangle()
                    .fill(Colors.primary)
                .frame(width: 30, height: 30)
                .mask(
                    Image("confirm_button")
                        .resizable()
                        .scaledToFit()
                )
            }
        }
    }
}

//struct ConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmationView()
//    }
//}
