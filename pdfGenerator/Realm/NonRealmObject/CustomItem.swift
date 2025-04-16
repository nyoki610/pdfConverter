//
//  Circle.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/04/07.
//

import SwiftUI
import RealmSwift


protocol CustomItem: View {
    /// 中心からの位置を -1.0〜1.0 の割合で表示
    var positionRate: CGSize { get set }

    /// 大きさを直接指定
    var size: CGFloat { get set }
}


struct CustomCircle: CustomItem {

    var positionRate: CGSize = CGSize(width: 0.0, height: 0.0)
    var size: CGFloat = DeviceType.model == .iPhone ? 50 : 100
    
    private let circleWidth: CGFloat = 4
    
    var body: some View {
        Circle()
            .stroke(Color.red, lineWidth: circleWidth)
            .frame(width: size-circleWidth, height: size-circleWidth)
    }
}

struct CustomArrow: CustomItem {
    
    var positionRate: CGSize = CGSize(width: 0.0, height: 0.0)
    var size: CGFloat = DeviceType.model == .iPhone ? 50 : 100
    
    var body: some View {
        Image(systemName: "line.diagonal.arrow")
            .font(.system(size: size))
            .foregroundColor(.red)
    }
}
