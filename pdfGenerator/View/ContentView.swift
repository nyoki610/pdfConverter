//
//  SwiftUIView.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/10.
//

import SwiftUI

struct ContentView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType
    
    @EnvironmentObject private var realmService: RealmService
    @EnvironmentObject private var alertSharedData: AlertSharedData
    
    private let contentId: String
    private var content: Content {
        realmService.selectedProject.contents.first(where: {$0.id==contentId}) ?? EmptyModel.content
    }
    private var index: Int? {
        realmService.selectedProject.contents.firstIndex(where: {$0.id==contentId})
    }
    
    @State private var userInputTitle: String = ""
    @State private var userInputDetail: String = ""
    
    @State private var showSheet: Bool = false
    @State private var selectedTargetType: TargetType?
    
    /// 親Viewと共有する変数 ImageEditorViewの表示内容を制御
    @Binding var selectedContentId: String
    @Binding var showImageEditorView: Bool
    
    init(contentId: String, selectedContentId: Binding<String>, showImageEditorView: Binding<Bool>) {
        self.contentId = contentId
        _selectedContentId = selectedContentId
        _showImageEditorView = showImageEditorView
    }
    
    enum TargetType: String {
        case issue = "問題点"
        case repairContent = "修繕内容"
        
        func options(realmService: RealmService) -> [Option] {
            switch self {
            case .issue: return realmService.titleOptions
            case .repairContent: return realmService.detailOptions
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                
                if let index = index {
                    VStack {
                        Text(String(index+1))
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
                }
                
                Spacer()
                DeleteButton {
                    alertSharedData.showSelectiveAlert(
                        title: "写真を削除",
                        message: "この操作は取り消せません",
                        closeAction: {},
                        rightButtonLabel: "削除",
                        rightButtonType: AlertSharedData.RightButtonType.destructive,
                        rightButtonAction: {
                            realmService.selectedProject.updateSelf(
                                realm: realmService.realm,
                                delete: content
                            )
                        }
                    )
                }
            }
            .padding(.bottom, 20)
            
            if !content.id.isEmpty {
                ImageFrame {
                    Image(uiImage: content.pdfImage.resizedToFit(CGSize: deviceType.photoSize))
                }
                .padding(.bottom, 10)
            }

            HStack {
                Spacer()
                TLButton(systemName: "plus.circle",
                         label: "画像に図形を挿入",
                         color: .blue,
                         verticalPadding: .fixed(nil),
                         horizontalPadding: .fixed(nil)) {
                    selectedContentId = content.id
                    showImageEditorView = true
                }
            }
            .padding(.bottom, 10)
            
            userInputView(content: content, targetType: .issue)
            userInputView(content: content, targetType: .repairContent)
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
        .sheet(isPresented: $showSheet) {
            halfModalView
                .presentationDetents([.medium])
        }
        .onChange(of: selectedTargetType) { _, newValue in
            showSheet = newValue != nil
        }
        .onChange(of: showSheet) { _, newValue in
            if !newValue {
                selectedTargetType = nil
            }
        }
        .onAppear {
            self.userInputTitle = content.issue
            self.userInputDetail = content.repairContent
        }
    }
    
    private func userInputView(
        content: Content,
        targetType: TargetType
    ) -> some View {
        
        VStack {
            HStack {
                Text(targetType.rawValue)
                    .fontWeight(.semibold)
                Spacer()
            }

            CustomTextField(
                userInput: (targetType == .issue) ? $userInputTitle : $userInputDetail,
                content: content,
                targetType: targetType
            )
            .padding(.bottom, 4)
            
            HStack {
                Spacer()
                
                TLButton(systemName: "plus.circle.fill",
                         label: "過去の入力内容をコピー",
                         color: .blue,
                         verticalPadding: .fixed(nil),
                         horizontalPadding: .fixed(nil)) {
                    selectedTargetType = targetType
                }
            }
            .padding(.bottom, 16)
        }
    }
}

extension ContentView {
    
    @ViewBuilder
    var halfModalView: some View {
        
        VStack {
            Text("過去の入力内容から選択")
                .fontWeight(.semibold)
                .font(.system(size: 18))
                .padding()
            
            ScrollView {
                let options: [Option] = selectedTargetType?.options(realmService: realmService) ?? []
                
                ForEach(options) { option in
                    Button {
                        content.updateSelf(
                            realm: realmService.realm,
                            issue: selectedTargetType == .issue ? option.label : nil,
                            repairContent: selectedTargetType == .repairContent ? option.label : nil
                        )
                        switch selectedTargetType {
                        case .issue: userInputTitle = option.label
                        case .repairContent: userInputDetail = option.label
                        default: break
                        }
                        selectedTargetType = nil
                    } label: {
                        Text(option.label).centered
                            .foregroundStyle(.black)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(4)
                    .padding(.horizontal, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}


