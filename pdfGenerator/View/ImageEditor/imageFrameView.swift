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
                Image(uiImage: customImage.resizedToFit(CGSize: deviceType.photoSize))
            } else {
                dragView(isScreenShot: false)
            }
        }
    }
    
    @ViewBuilder
    func dragView(isScreenShot: Bool) -> some View {
     
        ZStack {
            Image(uiImage: content.image.resizedToFit(maxWidth: deviceType.photoSize.width,
                                                      maxHeight: deviceType.photoSize.height))
            
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
                            self.customCircle?.positionRate.width += limited.width / deviceType.photoSize.width
                            self.customCircle?.positionRate.height += limited.height / deviceType.photoSize.height
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
                            self.customArrow?.positionRate.width += limited.width / deviceType.photoSize.width
                            self.customArrow?.positionRate.height += limited.height / deviceType.photoSize.height
                        }
                )
            }
        }
        .frame(width: deviceType.photoSize.width, height: deviceType.photoSize.height)
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
            switch itemType {
            case .circle:
                customItem
            case .arrow:
                customItem
                    .rotationEffect(Angle(degrees: CGFloat(arrowDegree)), anchor: .center)
            }
        }
        .padding(10) /// タップ領域を広げる
        .contentShape(Rectangle()) /// タップ可能範囲をRectangleに合わせる
        .offset(
            x: customItem.positionRate.width * deviceType.photoSize.width + dragOffset.width,
            y: customItem.positionRate.height * deviceType.photoSize.height + dragOffset.height
        )
    }
    
    private func limitOffset<T: CustomItem>(customItem: T?, proposedOffset: CGSize) -> CGSize {
        
        guard let customItem = customItem else { return .zero }
        
        let currentX = customItem.positionRate.width * deviceType.photoSize.width + proposedOffset.width
        let currentY = customItem.positionRate.height * deviceType.photoSize.height + proposedOffset.height

        let halfWidth = deviceType.photoSize.width / 2
        let halfHeight = deviceType.photoSize.height / 2
        let limitX = halfWidth - customItem.size / 2
        let limitY = halfHeight - customItem.size / 2

        let clampedX = min(max(currentX, -limitX), limitX) - customItem.positionRate.width * deviceType.photoSize.width
        let clampedY = min(max(currentY, -limitY), limitY) - customItem.positionRate.height * deviceType.photoSize.height

        return CGSize(width: clampedX, height: clampedY)
    }
}
