//
//  PDFGenerater.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/03/12.
//

import Foundation
import PDFKit

class PDFGenerator {
    
    static var tempURL: URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let tempURL = tempDirectory.appendingPathComponent("shared.pdf")
        return tempURL
    }
    
    static func savePDF(from project: Project, completion: @escaping (Bool) -> Void) {
        guard let pdfDocument = generatePDF(from: project),
              let data = pdfDocument.dataRepresentation() else {
            completion(false)
            return
        }
        
        /// 常に同じファイル名で上書き保存
        do {
            try data.write(to: tempURL, options: .atomic)
            completion(true)
        } catch {
            print("PDFの一時保存に失敗しました: \(error)")
            completion(false)
        }
    }
    
    static func generatePDF(from project: Project) -> PDFDocument? {

        let bounds = CGRect(x: 0, y: 0, width: PageLayout.A4_WIDTH, height: PageLayout.A4_HEIGHT)
        let renderer = UIGraphicsPDFRenderer(bounds: bounds)
        
        let data = renderer.pdfData { context in
            
            if let coverPage = project.coverPage {
                
                context.beginPage()
                
                let coverPageCell: Cell = Cell(startX: 0,
                                               startY: 0,
                                               width: PageLayout.A4_WIDTH,
                                               height: PageLayout.A4_HEIGHT)
                
                context.cgContext.insertImage(
                    image: coverPage,
                    cell: coverPageCell,
                    padding: 4
                )
            }
            
            /// ページごとの処理
            for (index, content) in project.contents.enumerated() {
                /// 新しいページを開始
                if index % 3 == 0 {
                    context.beginPage()
                    
                    let pageNumberCell: Cell = Cell(startX: PageLayout.pageNumberStartX,
                                                    startY: PageLayout.pageNumberStartY,
                                                    width: PageLayout.overallWidth,
                                                    height: PageLayout.pageNumberHeight)
                    
                    context.cgContext.insertText(
                        text: "Page \(index/3+1)",
                        cell: pageNumberCell,
                        verticalAlignment: .center,
                        horizontalAlignment: .trailing,
                        horizontalPadding: 10
                    )
                    
                    let projectTitleCell: Cell = Cell(startX: PageLayout.leftBorder,
                                                      startY: PageLayout.projectTitleStartY,
                                                      width: PageLayout.overallWidth,
                                                      height: PageLayout.projectTitleHeight)
                    
                    context.cgContext.insertStroke(cell: projectTitleCell)
                    
                    context.cgContext.insertText(
                        text: project.title,
                        cell: projectTitleCell,
                        verticalAlignment: .center,
                        horizontalAlignment: .leading,
                        horizontalPadding: 10
                    )
                }
                
                let contentCells = ContentCells(contentIndex: index)

                context.cgContext.insertStroke(cell: contentCells.content)
                context.cgContext.insertStroke(cell: contentCells.image)
                context.cgContext.insertStroke(cell: contentCells.index)
                context.cgContext.insertStroke(cell: contentCells.title)
                context.cgContext.insertStroke(cell: contentCells.detail)

                let imagePadding: CGFloat = 10
                    
                context.cgContext.insertImage(
                    image: content.pdfImage,
                    cell: contentCells.image,
                    padding: imagePadding
                )
                context.cgContext.insertText(
                    text: String(index+1),
                    cell: contentCells.index,
                    verticalAlignment: .center,
                    horizontalAlignment: .center
                )
                context.cgContext.insertText(
                    text: content.title,
                    cell: contentCells.title,
                    verticalAlignment: .center,
                    horizontalAlignment: .leading,
                    horizontalPadding: 10
                )
                context.cgContext.insertText(
                    text: content.detail,
                    cell: contentCells.detail,
                    verticalAlignment: .top,
                    horizontalAlignment: .leading,
                    verticalPadding: 10,
                    horizontalPadding: 10
                )
            }
        }
        
        return PDFDocument(data: data)
    }
}
