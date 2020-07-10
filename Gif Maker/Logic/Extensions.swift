//
//  Extensions.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/9/20.
//  Copyright © 2020 six. All rights reserved.
//

import Foundation
import SwiftUI

extension UIImage {
    func fixOrientation() -> UIImage? {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }

        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
