//
//  DeleteButton.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/11.
//

import SwiftUI

struct DeleteButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
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
}
