//
//  insertText.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/17.
//

import UIKit
import PDFKit
import SwiftUI


extension CGContext {
    
    func insertText(
        text: String,
        cell: Cell,
        verticalAlignment: VerticalAlignment,
        horizontalAlignment: HorizontalAlignment,
        verticalPadding: CGFloat = 0,
        horizontalPadding: CGFloat = 0
    ) {

        /// 属性付き文字列を作成
        let attributedText = NSAttributedString(string: text,
                                                attributes: getAttributes(horizontalAlignment))

        /// paddingを考慮した領域を設定
        let paddingRect = getPaddingRect(cell, verticalPadding, horizontalPadding)
        /// 折り返しを考慮した領域を設定
        let boundingRect = getBoundingRect(attributedText, paddingRect)
        /// 最終的に使用する領域を取得
        let finalRect = getFinalRect(paddingRect, boundingRect, verticalAlignment)
        
        print(paddingRect)
        print(boundingRect)

        /// attributedText を出力
        attributedText.draw(
            with: finalRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
    }
    
    private func getAttributes(_ horizontalAlignment: HorizontalAlignment) -> [NSAttributedString.Key: Any] {
        
        let fontSize: CGFloat = 10.5
        let mincho = UIFont(name: "NotoSerifJP-SemiBold", size: fontSize) ?? .systemFont(ofSize: fontSize)

        /// paragraphStyle を設定
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineBreakMode = .byWordWrapping /// 折り返し
        
        switch horizontalAlignment { /// 水平方向の配置
        case .leading:
            paragraphStyle.alignment = .left
        case .center:
            paragraphStyle.alignment = .center
        case .trailing:
            paragraphStyle.alignment = .right
        default:
            paragraphStyle.alignment = .left
        }

        let attributes: [NSAttributedString.Key: Any] = [
            .font: mincho,
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        
        return attributes
    }
    
    private func getPaddingRect(_ cell: Cell, _ verticalPadding: CGFloat, _ horizontalPadding: CGFloat) -> CGRect {
        
        return CGRect(
            x: cell.startX + horizontalPadding,
            y: cell.startY + verticalPadding,
            width: cell.width  - 2 * horizontalPadding,
            height: cell.height - 2 * verticalPadding
        )
    }
    
    private func getBoundingRect(_ attributedText: NSAttributedString, _ paddingRect: CGRect) -> CGRect {
        
        /// attributedText.boundingRect: 指定サイズ内でテキストを折り返した場合の必要短形を返す
        var boundingRect = attributedText.boundingRect(
            with: paddingRect.size, /// この CGSize 内で折り返す
            options: [
                /// 文字列を折り返す際、行フラグメントの原点（line fragment origin） を基準に矩形を求める
                .usesLineFragmentOrigin,
                /// フォントが定義する 行送り（leading） を高さ計算に含める
                .usesFontLeading
            ],
            /// 追加情報をやり取りするコンテキスト
            context: nil
        )
        
        /// 基準点を設定
        boundingRect.origin = paddingRect.origin
        
        return boundingRect
    }
    
    private func getFinalRect(
        _ paddingRect: CGRect,
        _ boundingRect: CGRect,
        _ verticalAlignment: VerticalAlignment
    ) -> CGRect {
        
        /// 垂直方向の offset  を計算
        let offsetY: CGFloat
        switch verticalAlignment {
        case .top:
            offsetY = 0
        case .center:
            offsetY = max((paddingRect.height - boundingRect.height) / 2, 0)
        case .bottom:
            offsetY = 0 /// 未実装
        case .firstTextBaseline:
            offsetY = 0
        case .lastTextBaseline:
            offsetY = 0
        default:
            offsetY = 0
        }

        /// 実際に描画する位置を再度設定
        let finalRect = CGRect(
            x: paddingRect.minX,
            y: paddingRect.minY + offsetY,
            width: paddingRect.width,
            height: boundingRect.height
        )
        
        return finalRect
    }
}
