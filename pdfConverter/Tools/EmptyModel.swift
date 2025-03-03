//
//  EmptyModel.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/01.
//

import Foundation

enum EmptyModel {
    
    static let project = Project(id: "", title: "", createdDate: Date(), lastUsedDate: Date(), contents: [])
    
    static let content = Content(id: "", img: Data(), title: "", detail: "")
}
