import SwiftUI
import PDFKit

struct PDFViewerView: View {
    
    @EnvironmentObject var realmService: RealmService
    
    private var pdfDocument: PDFDocument? { PDFDocument(url: PDFGenerator.tempURL) }
    
    var body: some View {
        
        VStack {
            
            if let pdfDocument = pdfDocument {
                // PDF表示部分
                PDFKitView(document: pdfDocument)
                    .frame(maxHeight: .infinity)
            }
            
            /// ShareLinkで直接PDFのDataを共有
            /// PDFDocument 型は直接は ShareLink に渡せない
            /// .dataRepresentation() で Data 型に変換してから渡す
            /// ② URLで共有
            HStack {
                ShareLink(item: PDFGenerator.tempURL, preview: SharePreview(realmService.selectedProject.title)) {
                    Label("共有", systemImage: "square.and.arrow.up")
                }
                Spacer()
            }
            .fontWeight(.bold)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
        }
    }
}


