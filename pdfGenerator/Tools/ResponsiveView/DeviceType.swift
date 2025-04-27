//
//  DeviceType.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/04/13.
//


import SwiftUI


enum DeviceType {
    case iPhone, iPad, unknown
    
    static var model: DeviceType {
        let model = UIDevice.current.model
        if model.contains("iPad") {
            return .iPad
        } else if model.contains("iPhone") {
            return .iPhone
        } else {
            return .unknown
        }
    }
    
    var description: String {
        switch self {
        case .iPhone: return "iPhone"
        case .iPad: return "iPad"
        default: return "unknown"
        }
    }
    
    var photoSize: CGSize {
        
        let imageRatio: CGFloat = PageLayout.contentsHeight / PageLayout.imageCellWidth
        
        let imageWidth: CGFloat = {
            switch self {
            case .iPhone: return 300
            case .iPad: return 600
            default: return 300
            }
        }()
    
        return CGSize(width: imageWidth, height: imageWidth * imageRatio)
    }
}

extension EnvironmentValues {
    @Entry var deviceType: DeviceType = DeviceType.model
}

