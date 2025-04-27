import SwiftUI
import PDFKit

struct PDFViewerView: View {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    @EnvironmentObject var realmService: RealmService
    
    @State private var pdfDocument: PDFDocument? = PDFDocument(url: PDFGenerator.tempURL)
    
    @State private var selectedFontSize: FontSize = .tenPointFive
    
    enum FontSize: CGFloat, CaseIterable, Identifiable {
        case ninePointFive = 9.5
        case ten = 10
        case tenPointFive = 10.5
        case eleven = 11
        case elvemPointFive = 11.5
        case twelve = 12
        case twelvePointFive = 12.5
        case thirteen = 13
        case thirteenPointFive = 13.5
        case fourteen = 14
        
        var id: Self { self }
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                Spacer()
                Text("文字サイズ：")
                    .fontWeight(.medium)
                Picker("文字サイズ", selection: $selectedFontSize) {
                    ForEach(FontSize.allCases) { fontSize in
                        Text(String(describing: fontSize.rawValue))
                    }
                }
                .onChange(of: selectedFontSize) { _, newValue in
                    pdfDocument = nil
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        PDFGenerator.savePDF(from: realmService.selectedProject,
                                             photoSize: deviceType.photoSize,
                                             fontSize: newValue.rawValue) { success in
                            DispatchQueue.main.async {
                                pdfDocument = PDFDocument(url: PDFGenerator.tempURL)
                            }
                        }
                    }
                }
                    
                Spacer()
            }
            
            if let pdfDocument = pdfDocument {
                // PDF表示部分
                PDFKitView(document: pdfDocument)
                    .frame(maxHeight: .infinity)
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(2.0)
                        .padding(.bottom, 10)
                    Text("PDFを生成中...")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                    Spacer()
                }
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
