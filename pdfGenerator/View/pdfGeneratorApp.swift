//
//  pdfConverterApp.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/02/22.
//

import SwiftUI

@main
struct pdfConverterApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.deviceType, DeviceType.model)
        }
    }
}
