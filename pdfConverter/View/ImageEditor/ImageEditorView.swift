//
//  ImageEditorView.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/04/06.
//

import SwiftUI

struct ImageEditorView: View {
    
    @EnvironmentObject var realmService: RealmService
    
    private let contentId: String
    var content: Content {
        realmService.selectedProject.contents.first {$0.id == contentId} ?? EmptyModel.content
    }
    
    /// ImageEditorView が開かれるたびに初期化
    @State var customCircle: CustomCircle?
    @State var customArrow: CustomArrow?
    
    @Binding var showImageEditorView: Bool

    @GestureState var circleOffset: CGSize = .zero
    @GestureState var arrowOffset: CGSize = .zero
    
    let frameSize = CGSize(width: 300, height: 200)
    
    init(contentId: String, showImageEditorView: Binding<Bool>) {
        print("ImageEditorView has been initialized!")
        self.contentId = contentId
        _showImageEditorView = showImageEditorView
    }
    
    enum CustomItemType: String {
        case circle = "円"
        case arrow = "矢印"
    }
    
    var body: some View {
        
        VStack {
            
            Text("画像に図形を挿入する")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top, 20)
            
            imageFrameView
            
            if customCircle != nil || customArrow != nil {
                Text("（ドラッグして図形を移動）")
                    .padding(.top, 10)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            
            Spacer()

            buttonView
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
}
