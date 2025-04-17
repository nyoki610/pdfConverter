//
//  ImageFrame.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/08.
//

import SwiftUI


struct ImageFrame<Content: View>: View {
    
    @Environment(\.deviceType) var deviceType
    
    let contentView: () -> Content
    let ratio: CGFloat
    
    init(ratio: CGFloat = 1.0, @ViewBuilder contentView: @escaping () -> Content) {
        self.contentView = contentView
        self.ratio = ratio
    }
    
    var body: some View {
        ZStack {
            contentView()
        }
        .frame(width: deviceType.photoSize.width * ratio,
               height: deviceType.photoSize.height * ratio)
        .padding(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black.opacity(0.3), lineWidth: 2)
        )
    }
}
