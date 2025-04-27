//
//  ButtonActions.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/27.
//

import SwiftUI

extension ContentsListView {
    
    func photosButtonAction() {
        
        guard !photoHandler.selectedItems.isEmpty else { return }
        
//        let scrollTargetIndex = realmService.selectedProject.contents.count

        photoHandler.addContents(
            project: realmService.selectedProject,
            realm: realmService.realm
        ) {
            /// error 要修正
//            if scrollTargetIndex < realmService.selectedProject.contents.count {
//                let scrollTargetId = realmService.selectedProject.contents[scrollTargetIndex].id
//                withAnimation {
//                    proxy.scrollTo(scrollTargetId, anchor: .center)
//                }
//            }
        }
    }
    
    func pdfButtonAction() {
        
        PDFGenerator.savePDF(from: realmService.selectedProject,
                             photoSize: deviceType.photoSize,
                             fontSize: 12) { success in
            
            if success {
                sharedData.path.append(.pdfViewer)
            } else {
                alertSharedData.showSingleAlert(title: "エラー",
                                                message: "PDFの生成に失敗しました",
                                                closeAction: {})
            }
        }
    }
}
