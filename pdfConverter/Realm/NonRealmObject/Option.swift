//
//  Option.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/04.
//

import Foundation


struct Option: Identifiable {
    
    let id: String = UUID().uuidString
    let label: String
    var count: Int = 0
}
