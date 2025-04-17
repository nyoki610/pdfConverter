//
//  test2.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/03/11.
//

import UIKit
import PDFKit
import SwiftUI

struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
