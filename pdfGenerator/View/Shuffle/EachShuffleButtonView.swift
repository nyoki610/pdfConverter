//
//  EachButtonView.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/08.
//

import SwiftUI

struct EachShuffleButtonView: View {
    
    let content: Content

    @Binding var contentIdList: [String]
    
    private var index: Int? {contentIdList.firstIndex {$0 == content.id}}
    
    var body: some View {
        Button {
            if let index = index {
                contentIdList.remove(at: index)
            } else {
                contentIdList.append(content.id)
            }
        } label: {
            ZStack {
                ImageFrame(ratio: 0.5) {
                    Image(uiImage: content.image.resizedToFit(maxWidth: 150, maxHeight: 100))
                }
                
                if let index = index {
                    Color(.blue.opacity(0.1))
                    Text("\(index+1)")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.blue.opacity(0.4)))
                }
            }
            .frame(width: 150, height: 100)
        }
    }
}
