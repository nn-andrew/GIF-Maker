//
//  CropToolsView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/14/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct CropToolsView: View {
    var body: some View {
        GeometryReader { geo in
            HStack {
                Button(action: {
                    
                }) {
                    Text("Custom")
                }
                
                Button(action: {
                    
                }) {
                    Text("Square")
                }
                
                Button(action: {
                    
                }) {
                    Text("4:3")
                }
                
                Button(action: {
                    
                }) {
                    Text("3:2")
                }
                
                Button(action: {
                    
                }) {
                    Text("16:9")
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Colors.gray6)
        }
    }
}

struct CropToolsView_Previews: PreviewProvider {
    static var previews: some View {
        CropToolsView()
    }
}
