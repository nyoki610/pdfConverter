//
//  CellHandler.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/03/11.
//

import Foundation

struct ContentCells {

    let content: Cell
    let image: Cell
    let index: Cell
    let title: Cell
    let detail: Cell
    
    init(contentIndex: Int) {
        
        let verticalOffset = PageLayout.contentsHeight * CGFloat(contentIndex % 3)
        let startY = PageLayout.contentsStartY + verticalOffset
        
        content = Cell(
            startX: PageLayout.leftBorder,
            startY: startY,
            width: PageLayout.overallWidth,
            height: PageLayout.contentsHeight
        )
        
        image = Cell(
            startX: PageLayout.leftBorder,
            startY: startY,
            width: PageLayout.imageCellWidth,
            height: PageLayout.imageCellHeight
        )
        
        index = Cell(
            startX: image.endX,
            startY: startY,
            width: PageLayout.indexCellWidth,
            height: PageLayout.indexCellHeight
        )
        
        title = Cell(
            startX: index.endX,
            startY: startY,
            width: PageLayout.titleCellWidth,
            height: PageLayout.titleCellHeight
        )
        
        detail = Cell(
            startX: image.endX,
            startY: index.endY,
            width: PageLayout.detailCellWidth,
            height: PageLayout.detailCellHeight
        )
    }
}
