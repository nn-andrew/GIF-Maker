//
//  ContentView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/7/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
//    @State private var image: Image?
//    @State private var inputImage: UIImage?
    @State private var movieURL: URL?
    @State private var showingImagePicker = false
    
    var gif = GIF()
    
    @State var frameIndex = 0

//    @ViewBuilder
    var body: some View {
        VStack {
            
//            if self.movieURL != nil {
//                PlayerView(url: self.$movieURL)
//                    .border(Color.blue)
//            }
            
            if self.gif.frames != [] && self.showingImagePicker == false {
                self.animatedFramesView
            }
            
            Button("Select Image") {
                self.showingImagePicker = true
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            self.makeGIF()
            
            // Force reload view
            self.showingImagePicker.toggle()
            self.showingImagePicker.toggle()
        }) {
//            ImagePicker(image: self.$inputImage)
            ImagePicker(movieURL: self.$movieURL, showPicker: self.$showingImagePicker)
        }
    }
    
//    @ViewBuilder
    var animatedFramesView: some View {
        // Frame to show in editor
        
        return VStack {
            Image(uiImage: self.gif.frames[min(self.frameIndex, self.gif.frames.count-1)])
        }
        .onAppear(perform: {
            Timer.scheduledTimer(withTimeInterval: self.gif.frameDelay, repeats: true, block: { timer in
                self.frameIndex += 1
            })
        })
    }
    
    func makeGIF() {
        self.gif.movieURL = self.movieURL
        gif.makeGIF()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
