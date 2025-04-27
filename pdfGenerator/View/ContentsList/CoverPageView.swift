//
//  CoverPageView.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/27.
//

import SwiftUI
import PhotosUI

extension ContentsListView {
    
    @ViewBuilder
    var coverPageView: some View {
        
        if let coverPage = realmService.selectedProject.coverPage {
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    VStack {
                        Text("表紙")
                            .fontWeight(.bold)
                            .font(.system(size: responsiveSize(18, 24)))
                    }
                    .padding(.vertical, 4)
                    .frame(width: responsiveSize(48, 60))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black.opacity(0.3), lineWidth: 2)
                    )
                    
                    Spacer()
                    
                    DeleteButton {
                        alertSharedData.showSelectiveAlert(title: "表紙をリセット",
                                                           message: "この操作は取り消せません",
                                                           closeAction: {},
                                                           rightButtonLabel: "リセット",
                                                           rightButtonType: .destructive,
                                                           rightButtonAction: {
                            realmService.selectedProject.resetCoverPage(realm: realmService.realm)
                        })
                    }
                }
                .padding(.bottom, 20)
                
                ImageFrame {
                    Image(uiImage: coverPage.resizedToFit(CGSize: deviceType.photoSize))
                }
                .padding(.bottom, 10)
                
                PhotosPicker(selection: $photoHandler.selectedCoverPage,
                             maxSelectionCount: 1,
                             matching: .images) {
                    VStack {
                        TLButton(systemName: "rectangle.fill.badge.plus",
                                 label: "表紙ページを変更",
                                 color: .blue,
                                 horizontalPadding: .fixed(nil),
                                 deviceType: deviceType) {
                            
                        }
                                 .allowsHitTesting(false)
                    }
                    .padding(.horizontal, 20)
                }
                             .onChange(of: photoHandler.selectedCoverPage) {
                                 photoHandler.addCoverPage(project: realmService.selectedProject, realm: realmService.realm)
                             }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black.opacity(0.3), lineWidth: 2)
            )
            .padding(10)
        } else {
            
            PhotosPicker(selection: $photoHandler.selectedCoverPage,
                         maxSelectionCount: 1,
                         matching: .images) {
                VStack {
                    Image(systemName: "plus")
                        .bold()
                        .font(.system(size: 24))
                        .padding(.bottom, 4)
                    Text("表紙ページを追加する")
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 40)
                .background(.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.black.opacity(0.3), lineWidth: 2)
                )
                .padding(.top, 40)
                .padding(.bottom, 10)
                .padding(.horizontal, 30)
            }
                         .onChange(of: photoHandler.selectedCoverPage) {
                             photoHandler.addCoverPage(project: realmService.selectedProject, realm: realmService.realm)
                         }
        }
    }
}
