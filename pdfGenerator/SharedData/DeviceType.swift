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
        switch self {
        case .iPhone: return CGSize(width: 300, height: 200)
        case .iPad: return CGSize(width: 600, height: 400)
        default: return CGSize(width: 300, height: 200)
        }
    }
}

extension EnvironmentValues {
    @Entry var deviceType: DeviceType = DeviceType.model
}

