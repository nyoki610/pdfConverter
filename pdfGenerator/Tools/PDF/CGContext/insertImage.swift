//
//  insertImage.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/17.
//

import UIKit
import PDFKit
import SwiftUI


extension CGContext {
    
    func insertImage(
        image: UIImage,
        cell: Cell,
        padding: CGFloat
    ) {

        let resizedImage = image.resizedToFit(
            maxWidth: cell.width - padding * 2,
            maxHeight: cell.height - padding * 2
        )

        let imageX = cell.startX + cell.width / 2 - resizedImage.size.width / 2
        let imageY = cell.startY + cell.height / 2 - resizedImage.size.height / 2

        let imageRect = CGRect(
            x: imageX,
            y: imageY,
            width: resizedImage.size.width,
            height: resizedImage.size.height
        )

        image.draw(in: imageRect)
    }
}
