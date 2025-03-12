//
//  PDFView.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/11.
//

import SwiftUI
import PDFKit

struct PDFViewerView: View {
    
    @EnvironmentObject var realmService: RealmService
    @State var pdfDocument: PDFDocument?

    var body: some View {
        
        VStack {
            HStack {
//                ShareLink(item: url) {
//                    Label("共有", systemImage: "square.and.arrow.up")
//                }
                Spacer()
                Button {
                    
                } label: {
                    Text("完了")
                }
            }
            .fontWeight(.bold)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
            
            if let pdfDocument = pdfDocument {
                PDFKitView(document: pdfDocument)
                    .frame(maxHeight: .infinity)
            } else {
                Text("PDFを生成中...")
            }
        }
        .onAppear {
            self.pdfDocument = PDFGenerator.generatePDF(from: realmService.selectedProject.contents)
        }
    }
}

