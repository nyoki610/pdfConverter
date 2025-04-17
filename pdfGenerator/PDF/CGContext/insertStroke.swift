//
//  insertStroke.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/17.
//

import UIKit
import PDFKit
import SwiftUI


extension CGContext {
    
    func insertStroke(cell: Cell) {
        let rect = CGRect(x: cell.startX, y: cell.startY, width: cell.width, height: cell.height)
        stroke(rect)
    }
}
