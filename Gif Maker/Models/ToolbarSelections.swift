//
//  ToolbarSelections.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/16/20.
//  Copyright © 2020 six. All rights reserved.
//

import Foundation
import SwiftUI

enum AspectRatio {
    case free
    case r4x3
    case r1x1
    case r3x2
    case r16x9
}

struct RectRatio {
    var width: CGFloat = 1
    var height: CGFloat = 1
    var originX: CGFloat = 0
    var originY: CGFloat = 0
}

enum TextFont {
    case montserrat
    case rubik
    case roboto
    case caveat
}

class TextOverlay: ObservableObject {
    var id = UUID()
    @Published var text: String = "Enter text"
    @Published var font: UIFont = UIFont(name: "Montserrat-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12)
    @Published var fontSize: CGFloat = 12
    @Published var color: UIColor = .white
    var rectRatio: RectRatio = RectRatio()
    
    var width: CGFloat = 100.0
    var height: CGFloat = 100.0
    var offsetTL: CGSize = .zero
    var offsetTR: CGSize = .zero
    var offsetBL: CGSize = .zero
    var offsetBR: CGSize = .zero
    var offsetTLAccumulate: CGSize = .zero
    var offsetTRAccumulate: CGSize = .zero
    var offsetBLAccumulate: CGSize = .zero
    var offsetBRAccumulate: CGSize = .zero
}

enum Adjustment {
    case saturation
    case brightness
    case contrast
}

class ToolbarSelections: ObservableObject {
    // Encompasses all the selections available in the toolbars
    static let shared = ToolbarSelections()
    
    @Published var cropRatio: AspectRatio = .free
    
    @Published var textOverlays: [TextOverlay] = []
    @Published var currentTextOverlay: TextOverlay?
    
    @Published var saturationAmount = 1.0
    @Published var brightnessAmount = 0.0
    @Published var contrastAmount = 1.0
    
    @Published var frameDelay = 15
}
