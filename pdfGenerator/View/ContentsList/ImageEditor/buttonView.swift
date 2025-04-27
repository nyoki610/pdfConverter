//
//  buttonView.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/08.
//

import SwiftUI

extension ImageEditorView {
    
    @ViewBuilder
    var buttonView: some View {
        
        VStack {
            
            Spacer()
            
            if let _ = content.customImage {
                
                VStack {
                    Text("この写真には")
                    Text("すでに図形が挿入されています")
                        .padding(.bottom, 10)
                    Text("編集する場合は")
                    Text("過去の編集内容をリセットしてください")
                        .padding(.bottom, 10)
                }
                .fontWeight(.medium)
                .padding(.bottom, 20)
                
                TLButton(systemName: "arrow.counterclockwise",
                         label: "過去の編集内容をリセット",
                         color: .red.opacity(0.8),
                         horizontalPadding: .fixed(40),
                         deviceType: deviceType) {
                    content.updateCustomImage(realm: realmService.realm,
                                              customImage: nil)
                    /// 念の為リセット
                    customCircle = nil
                    customArrow = nil
                    ///
                }
                         .padding(.horizontal, 20)
            } else {
                Spacer()
                editButtonView(customItem: customCircle,
                               itemType: .circle)
                
                Spacer()
                editButtonView(customItem: customArrow,
                               itemType: .arrow)
                Spacer()
            }
            
            Spacer()
            
            if customCircle == nil && customArrow == nil {
                TLButton(systemName: "xmark",
                         label: "閉じる",
                         color: .gray,
                         horizontalPadding: .fixed(40),
                         deviceType: deviceType) {
                    showImageEditorView = false
                    /// 念の為初期化
                    /// （ここで初期化しないと次回表示時にボタンのラベルが正しく表示されない）
                    customCircle = nil
                    customArrow = nil
                }
                         .padding(.horizontal, 40)
                         .padding(.bottom, 40)
            } else {
                TLButton(systemName: "square.and.arrow.down",
                         label: "保存して閉じる",
                         color: .blue,
                         horizontalPadding: .fixed(40),
                         deviceType: deviceType) {
                    
                    if customCircle != nil || customArrow != nil {
                        let renderer = ImageRenderer(content: dragView)
                        renderer.scale = UIScreen.main.scale
                        if let customImage = renderer.uiImage?.cropBottom() {
                            content.updateCustomImage(realm: realmService.realm,
                                                      customImage: customImage)
                        }
                    }
                    showImageEditorView = false
                    /// 念の為初期化
                    /// （ここで初期化しないと次回表示時にボタンのラベルが正しく表示されない）
                    customCircle = nil
                    customArrow = nil
                }
                         .padding(.horizontal, 40)
                         .padding(.bottom, 40)
            }
        }
    }
    
    @ViewBuilder
    private func editButtonView<T: CustomItem>(customItem: T?, itemType: CustomItemType) -> some View {
        
        if let customItem = customItem {
            
            sliderView(customItem: customItem,
                       itemType: itemType)
            .padding(.horizontal, 10)
        } else {
            
            TLButton(systemName: "plus",
                     label: "\(itemType.rawValue)を追加",
                     color: .green,
                     horizontalPadding: .fixed(40),
                     deviceType: deviceType) {
                /// customItem を初期化
                switch itemType {
                case .circle: customCircle = CustomCircle()
                case .arrow: customArrow = CustomArrow()
                }
            }
                     .padding(.horizontal, 20)
        }
    }
    
    
    @ViewBuilder
    private func sliderView<T: CustomItem>(customItem: T, itemType: CustomItemType) -> some View {
        
        HStack {
            
            Spacer()
            
            Button {
                switch itemType {
                case .circle:
                    customCircle = nil
                case .arrow:
                    customArrow = nil
                    arrowDegree = 0
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
                ZStack {
                 
                    Text(itemType.rawValue)
                        .font(.system(size: responsiveSize(20, 26)))
                        .fontWeight(.bold)
                    
                    HStack {
                        Spacer()
                        
                        if itemType == .arrow {
                            Button {
                                arrowDegree = (arrowDegree + 45) % 360
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("回転")
                                }
                                .bold()
                            }
                        }
                    }
                    
                }

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
                    in: deviceType == .iPhone ? 40...100 : 80...200
                )
                
                Text("（大きさを調整）")
                    .font(.system(size: responsiveSize(16, 20)))
                    .fontWeight(.medium)
                
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1), lineWidth: 0.5)
            )
            .padding(.horizontal, responsiveSize(10, 30))
            
            Spacer()
        }
        .frame(width: deviceType.photoSize.width)
    }
}

