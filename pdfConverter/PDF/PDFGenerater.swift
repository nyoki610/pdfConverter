//
//  PDFGenerater.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/12.
//

import Foundation
import PDFKit

class PDFGenerator {
    
    static func generatePDF(from contents: [Content]) -> PDFDocument? {

        let bounds = CGRect(x: 0, y: 0, width: PageLayout.A4_WIDTH, height: PageLayout.A4_HEIGHT)
        let renderer = UIGraphicsPDFRenderer(bounds: bounds)
        
        let data = renderer.pdfData { context in
            
            // ページごとの処理
            for (index, content) in contents.enumerated() {
                // 新しいページを開始
                if index % 3 == 0 {
                    context.beginPage()
                }
                
                let cellHandler = CellHandler(contentIndex: index)

                context.cgContext.insertStroke(cell: cellHandler.content)
                context.cgContext.insertStroke(cell: cellHandler.image)
                context.cgContext.insertStroke(cell: cellHandler.index)
                context.cgContext.insertStroke(cell: cellHandler.title)
                context.cgContext.insertStroke(cell: cellHandler.detail)

                let imagePadding: CGFloat = 10
                    
                context.cgContext.insertImage(
                    image: content.img,
                    cell: cellHandler.image,
                    padding: imagePadding
                )
                context.cgContext.insertText(
                    text: String(index),
                    cell: cellHandler.index,
                    verticalAlignment: .center,
                    horizontalAlignment: .center
                )
                context.cgContext.insertText(
                    text: content.title,
                    cell: cellHandler.title,
                    verticalAlignment: .center,
                    horizontalAlignment: .leading,
                    padding: 10
                )
                context.cgContext.insertText(
                    text: content.detail,
                    cell: cellHandler.detail,
                    verticalAlignment: .leading,
                    horizontalAlignment: .leading,
                    padding: 10
                )
            }
        }

//            // ヘッダー部分の描画
//            let headerText = "ブランズシティあべの王子町 屋上防水 点検記録    2024年10月7日"
//            let headerAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 12)
//            ]
//            headerText.draw(at: CGPoint(x: 20, y: 20), withAttributes: headerAttributes)

        
        return PDFDocument(data: data)
    }
}
