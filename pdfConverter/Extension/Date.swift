//
//  Date.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/02.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
    }
}
