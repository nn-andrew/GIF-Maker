//
//  FinishedView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/23/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct FinishedView: View {
    
    @State private var movieURL: URL?
    @State private var showingImagePicker = false
    @Binding var showFinishedView: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(Colors.gray6)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(spacing: 30) {
                    self.previewView
                    
                    Text("Congratulations! Your GIF is waiting in your camera roll.")
                        .foregroundColor(Color.primary)
                    
                    Button(action: {
                        self.showingImagePicker = true
                        
                        self.pauseFrames()
                    }) {
                        Text("Import")
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .frame(width: geo.size.width * 0.5)
                            .padding([.top, .bottom], 12)
                            .background(Colors.primary)
                            .cornerRadius(4)
                        
    //                    Image("import_button")
    //                        .renderingMode(.original)
    //                        .resizable()
    //                        .scaledToFit()
    //                        .frame(width: 100, height: 100)
                    }
                }
                .padding(40)
                .sheet(isPresented: self.$showingImagePicker, onDismiss: {
                    if GIF.shared.frames != [] && self.showingImagePicker == false {
                        self.showFinishedView = false
                    }
                }) {
                    ImagePicker(movieURL: self.$movieURL, showPicker: self.$showingImagePicker)
                }
            }
        }
    }
    
    // MARK: Frames
    @State var frameIndex = 0
    @State var timer: Timer?
    //@State var geoPreviewView: GeometryProxy?

    var previewView: some View {
        // Frame to show in editor
        
        return GeometryReader { geo in
            ZStack {
                Image(uiImage: GIF.shared.frames[self.frameIndex])
                    .resizable()
                    .scaledToFit()
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
            if self.frameIndex >= GIF.shared.trimEnd {
                self.frameIndex = GIF.shared.trimStart
            } else {
                self.frameIndex = (self.frameIndex + 1)
            }
        })
    }
    
    func pauseFrames() {
        self.timer?.invalidate()
    }
}

//struct FinishedView_Previews: PreviewProvider {
//    static var previews: some View {
//        FinishedView()
//    }
//}
