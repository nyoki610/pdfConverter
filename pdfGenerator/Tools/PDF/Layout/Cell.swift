//
//  Cell.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/03/12.
//

import Foundation

struct Cell {
    
    let startX: CGFloat
    let startY: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let width: CGFloat
    let height: CGFloat
    
    init(
        startX: CGFloat,
        startY: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) {
        self.startX = startX
        self.startY = startY
        self.width = width
        self.height = height
        self.endX = startX + width
        self.endY = startY + height
    }
}
