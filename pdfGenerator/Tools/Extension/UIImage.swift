//
//  UIImage.swift
//  pdfGenerator
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

extension UIImage {
    
    func resizedSize(maxWidth: CGFloat, maxHeight: CGFloat) -> CGSize {
        let aspectRatio = min(
            maxWidth / size.width,
            maxHeight / size.height
        )
        
        let newSize = CGSize(
            width: size.width * aspectRatio,
            height: size.height * aspectRatio
        )
        
        return newSize
    }
    
    func resizedToFit(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {

        let newSize = resizedSize(maxWidth: maxWidth, maxHeight: maxHeight)
        /// 第１引数　newSize: CGSize　新しい画像のサイズを指定
        /// 第２引数　opaque: Bool
        /// 第３引数　scale: CGFloat
        /// 第３引数　scale: CGFloat
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        /// 関数のスコープを抜ける際にコンテキストを適切に開放
        defer { UIGraphicsEndImageContext() }

        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    func resizedToFit(CGSize: CGSize) -> UIImage {
        return resizedToFit(maxWidth: CGSize.width, maxHeight: CGSize.height)
    }
}

/// UIImageの下部1pxを切り取る
/// (ImageRenderで描画したUIImageは下部に謎の下線が入る）)
extension UIImage {
    func cropBottom() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let bottom: CGFloat = 1.0
        
        let croppingRect = CGRect(x: 0,
                                  y: 0,
                                  width: self.size.width * self.scale,
                                  height: (self.size.height * self.scale) - bottom)
        
        /// Perform the cropping
        guard let croppedCGImage = cgImage.cropping(to: croppingRect) else { return nil }
        
        /// Convert back to UIImage
        return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
