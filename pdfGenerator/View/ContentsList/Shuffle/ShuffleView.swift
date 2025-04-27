//
//  ShuffleView.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/03/13.
//

import SwiftUI

struct ShuffleView: View {
    
    @Environment(\.deviceType) private var deviceType
    
    @EnvironmentObject private var realmService: RealmService
    @EnvironmentObject private var alertSharedData: AlertSharedData
    
    @State var contentIdList: [String] = []
    @Binding var showShuffleSheet: Bool
//    @State private var showAlert: Bool = false
    
    private var enableShuffleButton: Bool {
        contentIdList.count == realmService.selectedProject.contents.count
    }
    
    var body: some View {
        VStack {
            Text("並び変え")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            VStack {
                Text("並び替える順にタップして選択してください")
                Text("（すべての画像を選択すると並び替えを実行できます）")
            }
            .padding(.bottom, 10)
            .font(.system(size: 16))
            .fontWeight(.medium)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(stride(from: 0, to: realmService.selectedProject.contents.count, by: 2)), id: \.self) { index in
                        HStack(spacing: 0) {
                            // 左側のアイテム
                            
                            Spacer()

                            EachShuffleButtonView(content: realmService.selectedProject.contents[index],
                                                  contentIdList: $contentIdList)
                                
                            // 右側のアイテム（存在する場合）
                            if index + 1 < realmService.selectedProject.contents.count {
                                
                                EachShuffleButtonView(content: realmService.selectedProject.contents[index+1],
                                                      contentIdList: $contentIdList)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
            }
            .padding(.bottom, 10)
            
            VStack {
                
                TLButton(systemName: "shuffle",
                         label: "並び替え",
                         color: .green.opacity(enableShuffleButton ? 1.0 : 0.7),
                         horizontalPadding: .fixed(nil),
                         deviceType: deviceType) {

                    realmService.selectedProject.shuffleContents(realm: realmService.realm,
                                                                 contentIdList: contentIdList)
                    contentIdList = []
                }
                         .disabled(!enableShuffleButton)
                
                TLButton(systemName: "xmark",
                         label: "閉じる",
                         color: .gray,
                         horizontalPadding: .fixed(nil),
                         deviceType: deviceType) {
                    showShuffleSheet = false
                }
            }
            
            Spacer()
        }
    }
}
