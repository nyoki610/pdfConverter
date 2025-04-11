//
//  UIImage.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/12.
//

import SwiftUI


extension UIImage {
    /// JPEG形式でDataに変換
    func toJPEGData(quality: CGFloat = 0.8) -> Data {
        return self.jpegData(compressionQuality: quality) ?? Data()
    }
    
    /// PNG形式でDataに変換
    func toPNGData() -> Data? {
        return self.pngData()
    }

    func toSwiftUIImage() -> Image {
        return Image(uiImage: self)
    }
}
