//
//  Data.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/12.
//

import SwiftUI


extension Data {
    /// DataからUIImageに変換
    func toUIImage() -> UIImage {
        return UIImage(data: self) ?? UIImage()
    }
}
