//
//  EmptyModel.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/01.
//

import SwiftUI

enum EmptyModel {
    
    static let project = Project(id: "", title: "", createdDate: Date(), lastUsedDate: Date(), coverPage: nil, contents: [])
    
    static let content = Content(id: "",image: UIImage(), issue: "", repairContent: "", customImage: nil)
}
