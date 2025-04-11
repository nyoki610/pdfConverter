//
//  TLButton.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/04/07.
//

import SwiftUI

struct TLButton: View {
    
    let systemName: String?
    let label: String
    let color: Color
    let size: CGFloat
    let action: () -> Void
    
    init(systemName: String?, label: String, color: Color, size: CGFloat=18, action: @escaping () -> Void) {
        self.systemName = systemName
        self.label = label
        self.color = color
        self.size = size
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                if let systemName = systemName {
                    Image(systemName: systemName)
                }
                Text(label)
                Spacer()
            }
            .padding(.vertical, 10)
            .fontWeight(.bold)
            .font(.system(size: size))
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
