//
//  ImageFrameView.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/04/08.
//

import SwiftUI

extension ImageEditorView {
    
    @ViewBuilder
    var imageFrameView: some View {
        ImageFrame {
            if let customImage = content.customImage {
                Image(uiImage: customImage.resizedToFit(maxWidth: 300, maxHeight: 200))
            } else {
                dragView(isScreenShot: false)
            }
        }
    }
    
    @ViewBuilder
    func dragView(isScreenShot: Bool) -> some View {
     
        ZStack {
            Image(uiImage: content.image.resizedToFit(maxWidth: frameSize.width,
                                                      maxHeight: frameSize.height))
            
            if let customCircle = customCircle {
                customItemView(customItem: customCircle,
                               itemType: .circle,
                               isScreenShot: isScreenShot)
                .gesture(
                    DragGesture()
                        .updating($circleOffset) { value, state, _ in
                            state = limitOffset(customItem: customCircle,
                                                proposedOffset: value.translation)
                        }
                        .onEnded { value in
                            let limited = limitOffset(customItem: customCircle,
                                                      proposedOffset: value.translation)
                            self.customCircle?.positionRate.width += limited.width / frameSize.width
                            self.customCircle?.positionRate.height += limited.height / frameSize.height
                        }
                )
            }
            if let customArrow = customArrow {
                customItemView(customItem: customArrow,
                               itemType: .arrow,
                               isScreenShot: isScreenShot)
                .gesture(
                    DragGesture()
                        .updating($arrowOffset) { value, state, _ in
                            state = limitOffset(customItem: customArrow,
                                                proposedOffset: value.translation)
                        }
                        .onEnded { value in
                            let limited = limitOffset(customItem: customArrow,
                                                      proposedOffset: value.translation)
                            self.customArrow?.positionRate.width += limited.width / frameSize.width
                            self.customArrow?.positionRate.height += limited.height / frameSize.height
                        }
                )
            }
        }
        .frame(width: 300, height: 200)
        .background(.white)
    }
    
    @ViewBuilder
    private func customItemView<T: CustomItem>(customItem: T, itemType: CustomItemType, isScreenShot: Bool) -> some View {
        
        let dragOffset: CGSize = {
            switch itemType {
            case .circle: return circleOffset
            case .arrow: return arrowOffset
            }
        }()
        
        VStack {
            customItem
        }
        .padding(10) /// タップ領域を広げる
        .contentShape(Rectangle()) /// タップ可能範囲をRectangleに合わせる
        .offset(
            x: customItem.positionRate.width * frameSize.width + dragOffset.width,
            y: customItem.positionRate.height * frameSize.height + dragOffset.height
        )
    }
    
    private func limitOffset<T: CustomItem>(customItem: T?, proposedOffset: CGSize) -> CGSize {
        
        guard let customItem = customItem else { return .zero }
        
        let currentX = customItem.positionRate.width * frameSize.width + proposedOffset.width
        let currentY = customItem.positionRate.height * frameSize.height + proposedOffset.height

        let halfWidth = frameSize.width / 2
        let halfHeight = frameSize.height / 2
        let limitX = halfWidth - customItem.size / 2
        let limitY = halfHeight - customItem.size / 2

        let clampedX = min(max(currentX, -limitX), limitX) - customItem.positionRate.width * frameSize.width
        let clampedY = min(max(currentY, -limitY), limitY) - customItem.positionRate.height * frameSize.height

        return CGSize(width: clampedX, height: clampedY)
    }
}
