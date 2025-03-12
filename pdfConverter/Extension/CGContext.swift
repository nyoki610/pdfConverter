//
//  CGContext.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/11.
//

import UIKit
import PDFKit

extension CGContext {
    
//    func insertLine(x: CGFloat, y: CGFloat, length: CGFloat, orientation: LineOrientation) {
//        let endPoint: CGPoint = switch orientation {
//            case .horizontal: CGPoint(x: x + length, y: y)
//            case .vertical: CGPoint(x: x, y: y + length)
//        }
//        move(to: CGPoint(x: x, y: y))
//        addLine(to: endPoint)
//        strokePath()
//    }
    
    func insertStroke(cell: Cell) {
        let rect = CGRect(x: cell.startX, y: cell.startY, width: cell.width, height: cell.height)
        stroke(rect)
    }
    
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
    
    func insertText(
        text: String,
        cell: Cell,
        verticalAlignment: Alignment,
        horizontalAlignment: Alignment,
        padding: CGFloat = 0
    ) {
        let fontSize: CGFloat = 12
        let mincho = UIFont(name: "YuGothic-Regular", size: 10.5) ?? .systemFont(ofSize: fontSize)
        
        // テキストの属性を設定
        let attributes: [NSAttributedString.Key: Any] = [
            .font: mincho,
            .foregroundColor: UIColor.black
        ]
        
        // テキストのサイズを計算
        let textSize = text.size(withAttributes: attributes)
        
        var indexX: CGFloat {
            switch horizontalAlignment {
            case .leading: return cell.startX + padding
            case .center: return cell.startX + (cell.width - textSize.width) / 2
            }
        }
        
        var indexY: CGFloat {
            switch verticalAlignment {
            case .leading: return cell.startY + padding
            case .center: return cell.startY + (cell.height - textSize.height) / 2
            }
        }
        
        // テキストを描画
        text.draw(
            at: CGPoint(x: indexX, y: indexY),
            withAttributes: attributes
        )
    }
    
    enum Alignment {
        case leading
        case center
    }


    enum LineOrientation {
        case horizontal
        case vertical
    }
}
