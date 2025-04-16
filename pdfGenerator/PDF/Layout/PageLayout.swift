//
//  PageLayout.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/12.
//

import Foundation


enum PageLayout {
    
    static let (A4_WIDTH, A4_HEIGHT): (CGFloat, CGFloat) = (595.2, 841.8)
    
    /// 上下左右のパディングを設定
    static let verticalMargin: CGFloat = 48
    static let horizontalMargin: CGFloat = 54
    static let leftBorder: CGFloat = horizontalMargin
    static let rightBorder: CGFloat = A4_WIDTH - horizontalMargin
    static let overallWidth: CGFloat = rightBorder - leftBorder
    
    /// ページ番号の縦幅を設定
    static let pageNumberStartX: CGFloat = rightBorder - 72
    static let pageNumberStartY: CGFloat = verticalMargin
    static let pageNumberHeight: CGFloat = 20
    static let pageNumberPaddingBottom: CGFloat = 10
    /// ページタイトルの縦幅を設定
    static let projectTitleStartY: CGFloat = pageNumberStartY + pageNumberHeight + pageNumberPaddingBottom
    static let projectTitleHeight: CGFloat = 30
    
    static let contentsStartY: CGFloat = projectTitleStartY + projectTitleHeight
    /// 各セルのサイズを決定
    static let contentsHeight: CGFloat = (A4_HEIGHT - verticalMargin * 2 - pageNumberHeight - projectTitleHeight) / 3
    
    static let imageCellWidth: CGFloat = 296
    static let imageCellHeight: CGFloat = contentsHeight
    
    static let indexCellWidth: CGFloat = 30
    static let indexCellHeight: CGFloat = 30
    
    static let titleCellWidth: CGFloat = overallWidth - (imageCellWidth + indexCellWidth)
    static let titleCellHeight: CGFloat = indexCellHeight
    
    static let detailCellWidth: CGFloat = indexCellWidth + titleCellWidth
    static let detailCellHeight: CGFloat = contentsHeight - indexCellHeight
}
