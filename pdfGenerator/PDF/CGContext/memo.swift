////
////  memo.swift
////  pdfGenerator
////
////  Created by 二木裕也 on 2025/04/17.
////
//
//import Foundation
//
//
//func _insertText(
//        text: String,
//        cell: Cell,
//        verticalAlignment: Alignment,
//        horizontalAlignment: Alignment,
//        padding: CGFloat = 0
//    ) {
//        let fontSize: CGFloat = 12
//        let mincho = UIFont(name: "YuGothic-Regular", size: 10.5) ?? .systemFont(ofSize: fontSize)
//        
//        // テキストの属性を設定
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: mincho,
//            .foregroundColor: UIColor.black
//        ]
//        
//        // テキストのサイズを計算
//        let textSize = text.size(withAttributes: attributes)
//        
//        var indexX: CGFloat {
//            switch horizontalAlignment {
//            case .leading: return cell.startX + padding
//            case .center: return cell.startX + (cell.width - textSize.width) / 2
//            }
//        }
//        
//        var indexY: CGFloat {
//            switch verticalAlignment {
//            case .leading: return cell.startY + padding
//            case .center: return cell.startY + (cell.height - textSize.height) / 2
//            }
//        }
//        
//        // テキストを描画
//        text.draw(
//            at: CGPoint(x: indexX, y: indexY),
//            withAttributes: attributes
//        )
//    } この関数について、セル内で折り返しが行われるように修正してください
