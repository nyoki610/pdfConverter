//
//  PageLayout.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/12.
//

import Foundation


enum PageLayout {
    
    static let (A4_WIDTH, A4_HEIGHT): (CGFloat, CGFloat) = (595.2, 841.8)
    static let verticalMargin: CGFloat = 80
    static let horizontalMargin: CGFloat = 54
    
    static let leftBorder: CGFloat = horizontalMargin
    static let rightBorder: CGFloat = A4_WIDTH - horizontalMargin
    
    static let contentsWidth = rightBorder - leftBorder
    static let contentsHeight: CGFloat = (A4_HEIGHT - verticalMargin * 2) / 3
    
    static let imageCellWidth: CGFloat = 296
    static let imageCellHeight: CGFloat = contentsHeight
    
    static let indexCellWidth: CGFloat = 30
    static let indexCellHeight: CGFloat = 30
    
    static let titleCellWidth: CGFloat = contentsWidth - (imageCellWidth + indexCellWidth)
    static let titleCellHeight: CGFloat = indexCellHeight
    
    static let detailCellWidth: CGFloat = indexCellWidth + titleCellWidth
    static let detailCellHeight: CGFloat = contentsHeight - indexCellHeight
}
