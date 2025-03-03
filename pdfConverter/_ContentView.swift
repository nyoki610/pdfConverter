//
//  ContentView.swift
//  PDFViewer
//
//  Created by hiroshi yamato on 2020/11/03.
//

import SwiftUI
import PDFKit

class PDFInfo: ObservableObject {
    @Published var pageNo: Int = 1
    @Published var pdfView: PDFView = PDFView()
    @Published var stateTopButton: Bool = false
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.pageChanged(_:)), name: Notification.Name.PDFViewPageChanged, object: nil)
    }
    
    @objc func pageChanged(_ notification: Notification) {
        pageNo = pdfView.currentPage!.pageRef!.pageNumber
        stateTopButton = pdfView.canGoToFirstPage
        print(self.pageNo)
        print("page is changed")
    }
}

struct _ContentView: View {
    @ObservedObject var pdfInfo: PDFInfo = PDFInfo()
    
    var body: some View {
        VStack {
            ShowPDFView(pdfInfo: pdfInfo)
            PdfInfoView(pdfInfo: pdfInfo)
            .padding()
        }.onAppear(){
            pdfInfo.addObserver()
        }
        
    }
}

struct ShowPDFView: View {
    @ObservedObject var pdfInfo: PDFInfo
    
    var body: some View {
        PDFViewer(pdfInfo: pdfInfo)
    }
}

struct PdfInfoView: View {
    @ObservedObject var pdfInfo: PDFInfo
    @State var enableTopButton: Bool = true
    
    var body: some View {
        HStack{
            Text(String(pdfInfo.pageNo))
            // Group / HStack / VStack / ZStack　でwrapされているとそこで条件式が使える
//            if (!pdfInfo.pdfView.canGoToFirstPage) {
//                Button(action: {
//                    pdfInfo.pdfView.goToFirstPage(self)
//                }, label: {
//                    Text("TOP")
//                })
//                .hidden()
//            } else {
//                Button(action: {
//                    pdfInfo.pdfView.goToFirstPage(self)
//                }, label: {
//                    Text("TOP")
//                })
//            }
            
            // ボタンの状態を変えてクリック無効にする場合はこちら
            Button(action: {
                pdfInfo.pdfView.goToFirstPage(self)
            }, label: {
                Text("TOP")
            })
            .disabled(!pdfInfo.stateTopButton)
        }
    }
}


struct PDFViewer: UIViewRepresentable {
    @ObservedObject var pdfInfo: PDFInfo
    
    let url: URL = Bundle.main.url(forResource: "数列の基礎", withExtension: "pdf")!
    
    func makeUIView(context: UIViewRepresentableContext<PDFViewer>) -> PDFViewer.UIViewType {
        // 画面サイズに合わす
        pdfInfo.pdfView.autoScales = true
        // 単一ページのみ表示（これを入れるとページめくりができない）
//        pdfView.displayMode = .singlePage
        //pageViewControllerを利用して表示(displayModeは無視される)
        pdfInfo.pdfView.usePageViewController(true)
        //スクロール方向を水平方向へ
        //pdfInfo.pdfView.displayDirection = .horizontal
        //スクロール方向を垂直方向へ
        pdfInfo.pdfView.displayDirection = .vertical
        //余白を入れる
//        pdfInfo.pdfView.displaysPageBreaks = true
        
        pdfInfo.pdfView.document = PDFDocument(url: url)

        return pdfInfo.pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFViewer>) {
    }
    
}
