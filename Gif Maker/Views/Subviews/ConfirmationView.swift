//
//  ConfirmationView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/14/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct ConfirmationView: View {
    @Binding var isPresentingView: Bool
    var body: some View {
        HStack {
            Button(action: {
                self.isPresentingView = false
            }) {
                Text("Cancel")
            }
            Button(action: {
                self.isPresentingView = false
                GIF.shared.generateFrames()
            }) {
                Text("Confirm")
            }
        }
    }
}

//struct ConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmationView()
//    }
//}
