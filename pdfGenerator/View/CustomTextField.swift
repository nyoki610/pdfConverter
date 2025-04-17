//
//  CustomTextField.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/03/10.
//

import SwiftUI

struct CustomTextField: View {
    @EnvironmentObject private var realmService: RealmService
    @Binding var userInput: String
    let content: Content
    let targetType: ContentView.TargetType
    @FocusState var isFocused: Bool
    
    init(
        userInput: Binding<String>,
        content: Content,
        targetType: ContentView.TargetType
    ) {
        _userInput = userInput
        self.content = content
        self.targetType = targetType
    }
    
    var body: some View {
        TextField("タップして\(targetType.rawValue)を入力", text: $userInput)
            .focused($isFocused)
            .onChange(of: isFocused) { _, newValue in
                if !newValue {
                    content.updateSelf(
                        realm: realmService.realm,
                        issue: (targetType == .issue) ? userInput : nil,
                        repairContent: (targetType == .repairContent) ? userInput : nil
                    )
                }
            }
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.black.opacity(0.3), lineWidth: 2)
            )
    }
}
