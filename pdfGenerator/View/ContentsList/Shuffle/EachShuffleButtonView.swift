//
//  EachButtonView.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/08.
//

import SwiftUI

struct EachShuffleButtonView: View {
    
    @Environment(\.deviceType) var deviceType
    
    let content: Content

    @Binding var contentIdList: [String]
    
    private var index: Int? {contentIdList.firstIndex {$0 == content.id}}
    
    private var ratio: CGFloat {
        switch deviceType {
        case .iPhone: return 0.5
        case .iPad: return 0.3
        default: return 0.5
        }
    }
    
    var body: some View {
        Button {
            if let index = index {
                contentIdList.remove(at: index)
            } else {
                contentIdList.append(content.id)
            }
        } label: {
            ZStack {
                ImageFrame(ratio: ratio) {
                    Image(uiImage: content.image.resizedToFit(maxWidth: deviceType.photoSize.width * ratio,
                                                              maxHeight: deviceType.photoSize.height * ratio))
                }
                
                if let index = index {
                    Color(.green.opacity(0.2))
                    Text("\(index+1)")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color.green.opacity(0.5)))
                }
            }
            .frame(width: deviceType.photoSize.width * ratio,
                   height: deviceType.photoSize.height * ratio)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }
}
