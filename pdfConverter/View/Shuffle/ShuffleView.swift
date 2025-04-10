//
//  ShuffleView.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/13.
//

import SwiftUI

struct ShuffleView: View {
    
    @EnvironmentObject private var realmService: RealmService
    
    var body: some View {
        VStack {
            Text("並び変え")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(stride(from: 0, to: realmService.selectedProject.contents.count, by: 2)), id: \.self) { index in
                        HStack(spacing: 0) {
                            // 左側のアイテム
                            
                            Spacer()
                            
                            ImageFrame(ratio: 0.5) {
                                Image(uiImage: realmService.selectedProject.contents[index].image.resizedToFit(maxWidth: 150, maxHeight: 100))
                            }
                                
                            // 右側のアイテム（存在する場合）
                            if index + 1 < realmService.selectedProject.contents.count {
                                
                                Spacer()
                                
                                ImageFrame(ratio: 0.5) {
                                    Image(uiImage: realmService.selectedProject.contents[index+1].image.resizedToFit(maxWidth: 150, maxHeight: 100))
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
            }
            
            Spacer()
        }
    }
}
