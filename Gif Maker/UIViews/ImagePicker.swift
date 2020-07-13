//
//  ImagePicker.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/8/20.
//  Copyright © 2020 six. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var movieURL: URL?
    @Binding var showPicker: Bool
    @Binding var gif: GIF

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            self.parent.showPicker = false
            if let movieURL = info[.mediaURL] as? URL {
                self.parent.movieURL = movieURL
                 
                // Setup GIF editing immediately after picking video
                self.parent.gif.movieURL = parent.movieURL
                self.parent.gif.generateFrames()
                self.parent.gif.makeGIF(fileName: "user-gif")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}
