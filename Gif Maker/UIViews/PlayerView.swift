//
//  PlayerView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/8/20.
//  Copyright © 2020 six. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

struct PlayerView: UIViewRepresentable {
    @Binding var url: URL?
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
        
    }

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(url: self.url)
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()

    init(url: URL?) {
        super.init(frame: .zero)
        
        guard url != nil else { return }
        
        let player = AVPlayer(url: url!)
        player.play()
        
        playerLayer.player = player
        layer.addSublayer(playerLayer)
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
