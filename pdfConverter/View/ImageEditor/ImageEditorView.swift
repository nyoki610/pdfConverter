//
//  ImageEditorView.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/04/06.
//

import SwiftUI

struct ImageEditorView: View {
    
    @EnvironmentObject var realmService: RealmService
    
    private let contentId: String
    private var content: Content {
        realmService.selectedProject.contents.first {$0.id == contentId} ?? EmptyModel.content
    }
    
    /// ImageEditorView が開かれるたびに初期化
    @State private var customCircle: CustomCircle?
    @State private var customArrow: CustomArrow?
    
    @Binding private var showImageEditorView: Bool

    @GestureState private var circleOffset: CGSize = .zero
    @GestureState private var arrowOffset: CGSize = .zero
    
    private let frameSize = CGSize(width: 300, height: 200)
    
    init(contentId: String, showImageEditorView: Binding<Bool>) {
        print("ImageEditorView has been initialized!")
        self.contentId = contentId
        _showImageEditorView = showImageEditorView
    }
    
    var body: some View {
        
        VStack {
            
            ImageFrame {
                if let customImage = content.customImage {
                    Image(uiImage: customImage.resizedToFit(maxWidth: 300, maxHeight: 200))
                } else {
                    editView(isScreenShot: false)
                }
            }
            
            Spacer()
            
            if let _ = content.customImage {
                TLButton(systemName: nil,
                         label: "変更をリセット",
                         color: .green) {
                    content.updateCustomImage(realm: realmService.realm,
                                              customImage: nil)
                }
            } else {
                editButtonView(customItem: customCircle,
                               itemType: .circle)
                editButtonView(customItem: customArrow,
                               itemType: .arrow)
            }
            
            Spacer()

            TLButton(systemName: nil,
                     label: "保存する",
                     color: .blue) {
                
                if customCircle != nil || customArrow != nil {
                    let renderer = ImageRenderer(content: editView(isScreenShot: true))
                    renderer.scale = UIScreen.main.scale
                    if let customImage = renderer.uiImage {
                        content.updateCustomImage(realm: realmService.realm,
                                                  customImage: customImage)
                    }
                }
                showImageEditorView = false
            }
                     .padding(.horizontal, 20)
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
        .padding()
    }
    
    @ViewBuilder
    private func editButtonView<T: CustomItem>(customItem: T?, itemType: CustomItemType) -> some View {
        
        if let customItem = customItem {
            
            sliderView(customItem: customItem,
                       itemType: itemType)
                .padding(.horizontal, 20)
        } else {
            
            TLButton(systemName: "plus",
                     label: "\(itemType.rawValue)を追加",
                     color: .green) {
                /// customItem を初期化
                switch itemType {
                case .circle: customCircle = CustomCircle()
                case .arrow: customArrow = CustomArrow()
                }
            }
        }
    }
    
    @ViewBuilder
    private func editView(isScreenShot: Bool) -> some View {
     
        ZStack {
            Image(uiImage: content.image.resizedToFit(maxWidth: frameSize.width, maxHeight: frameSize.height))
            
            if let customCircle = customCircle {
                editItemView(customItem: customCircle,
                             itemType: .circle,
                             isScreenShot: isScreenShot)
                .gesture(
                    DragGesture()
                        .updating($circleOffset) { value, state, _ in
                            state = limitOffset(value.translation)
                        }
                        .onEnded { value in
                            let limited = limitOffset(value.translation)
                            self.customCircle?.positionRate.width += limited.width / frameSize.width
                            self.customCircle?.positionRate.height += limited.height / frameSize.height
                        }
                )
            }
            if let customArrow = customArrow {
                editItemView(customItem: customArrow,
                             itemType: .arrow,
                             isScreenShot: isScreenShot)
                .gesture(
                    DragGesture()
                        .updating($arrowOffset) { value, state, _ in
                            state = limitOffset(value.translation)
                        }
                        .onEnded { value in
                            let limited = limitOffset(value.translation)
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
    private func editItemView<T: CustomItem>(customItem: T, itemType: CustomItemType, isScreenShot: Bool) -> some View {
        
        let dragOffset: CGSize = {
            switch itemType {
            case .circle: return circleOffset
            case .arrow: return arrowOffset
            }
        }()
        
        VStack {
            customItem
        }
        .frame(width: customItem.size, height: customItem.size)
        .background(.blue.opacity(isScreenShot ? 0.0 : 0.3))
        .offset(
            x: customItem.positionRate.width * frameSize.width + dragOffset.width,
            y: customItem.positionRate.height * frameSize.height + dragOffset.height
        )
    }
    
    enum CustomItemType: String {
        case circle = "円"
        case arrow = "矢印"
    }
    
    private func limitOffset(_ proposedOffset: CGSize) -> CGSize {
        
        guard let customCircle = customCircle else { return .zero }
        
        let currentX = customCircle.positionRate.width * frameSize.width + proposedOffset.width
        let currentY = customCircle.positionRate.height * frameSize.height + proposedOffset.height

        let halfWidth = frameSize.width / 2
        let halfHeight = frameSize.height / 2
        let limitX = halfWidth - customCircle.size / 2
        let limitY = halfHeight - customCircle.size / 2

        let clampedX = min(max(currentX, -limitX), limitX) - customCircle.positionRate.width * frameSize.width
        let clampedY = min(max(currentY, -limitY), limitY) - customCircle.positionRate.height * frameSize.height

        return CGSize(width: clampedX, height: clampedY)
    }
    
    @ViewBuilder
    private func sliderView<T: CustomItem>(customItem: T, itemType: CustomItemType) -> some View {
        
        HStack {
            
            Spacer()
            
            Button {
                switch itemType {
                case .circle: customCircle = nil
                case .arrow: customArrow = nil
                }
            } label: {
                VStack {
                    Image(systemName: "trash.fill")
                    Text("削除")
                }
                .fontWeight(.bold)
                .foregroundColor(.red)
            }
            
            Spacer()
            
            
            
            VStack {
                Text(itemType.rawValue)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                
                
                Slider(
                    value: Binding(
                        get: { customItem.size },
                        set: { newValue in
                            switch itemType {
                            case .circle: self.customCircle?.size = newValue
                            case .arrow: self.customArrow?.size = newValue
                            }
                        }
                    ),
                    in: 40...120
                )
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1), lineWidth: 0.5)
            )
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
