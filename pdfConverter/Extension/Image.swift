//
//  Image.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/11.
//

import SwiftUI

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
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        /// 関数のスコープを抜ける際にコンテキストを適切に開放
        defer { UIGraphicsEndImageContext() }

        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
