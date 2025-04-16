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
    let verticalPadding: VerticalPadding
    let horizontalPadding: HorizontalPadding
    let action: () -> Void
    
    init(systemName: String?,
         label: String,
         color: Color,
         size: CGFloat?=nil,
         verticalPadding: VerticalPadding,
         horizontalPadding: HorizontalPadding,
         action: @escaping () -> Void) {
        self.systemName = systemName
        self.label = label
        self.color = color
        self.size = size ?? (DeviceType.model == .iPhone ? 18 : 22)
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.action = action
    }
    
    enum VerticalPadding {
        case none, fixed(CGFloat?)
    }
    
    enum HorizontalPadding {
        case infinity, fixed(CGFloat?)
    }

    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                switch horizontalPadding {
                case .infinity:
                    HStack {
                        Spacer()
                        if let systemName = systemName {
                            Image(systemName: systemName)
                        }
                        Text(label)
                        Spacer()
                    }
                case .fixed(let padding):
                    HStack {
                        if let systemName = systemName {
                            Image(systemName: systemName)
                        }
                        Text(label)
                    }
                    .padding(.horizontal, padding ?? 10)
                }
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
