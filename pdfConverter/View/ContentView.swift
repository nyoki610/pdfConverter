//
//  SwiftUIView.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/10.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var realmService: RealmService
    @EnvironmentObject private var alertSharedData: AlertSharedData
    
    @State private var content: Content
    @State private var userInputTitle: String
    @State private var userInputDetail: String
    
    @State private var showSheet: Bool = false
    @State private var selectedTargetType: TargetType?
    
    init(content: Content) {
        self.content = content
        self.userInputTitle = content.title
        self.userInputDetail = content.detail
    }
    
    enum TargetType: String {
        case title = "詳細"
        case detail = "修繕内容"
        
        func options(realmService: RealmService) -> [Option] {
            switch self {
            case .title: return realmService.titleOptions
            case .detail: return realmService.detailOptions
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
                deleteButton
            }
            .padding(.bottom, 20)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    Image(uiImage: content.img.resizedToFit(maxWidth: 300, maxHeight: 160))

                    Spacer()
                }
                Spacer()
            }
            .frame(width: 300, height: 160)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.black.opacity(0.3), lineWidth: 2)
            )
            .padding(.bottom, 4)
            
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "pencil.line")
                        Text("画像を編集")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
                }
            }
            .padding(.bottom, 10)
            
            userInputView(content: content, targetType: .title)
            userInputView(content: content, targetType: .detail)
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
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        Button {
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
        } label: {
            HStack {
                Image(systemName: "trash.fill")
                Text("削除")
            }
            .fontWeight(.bold)
            .foregroundColor(.red)
        }
        .buttonStyle(.automatic)
    }
    
    private func userInputView(
        content: Content,
        targetType: TargetType
    ) -> some View {
        
        VStack {
            HStack {
                Text(targetType.rawValue)
                Spacer()
            }

            CustomTextField(
                userInput: (targetType == .title) ? $userInputTitle : $userInputDetail,
                content: content,
                targetType: targetType
            )
            .padding(.bottom, 4)
            
            HStack {
                Spacer()
                Button {
                    selectedTargetType = targetType
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("過去の入力内容をコピー")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
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
                            title: selectedTargetType == .title ? option.label : nil,
                            detail: selectedTargetType == .detail ? option.label : nil
                        )
                        switch selectedTargetType {
                        case .title: userInputTitle = option.label
                        case .detail: userInputDetail = option.label
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


