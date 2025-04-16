//
//  Date.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/02.
//

import Foundation

extension Date {
    
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
    }
    
    func toJapaneseDateString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter.string(from: self)
    }
}
