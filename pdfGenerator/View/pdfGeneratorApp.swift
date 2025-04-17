//
//  pdfGeneratorApp.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/02/22.
//

import SwiftUI

@main
struct pdfGeneratorApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.deviceType, DeviceType.model)
        }
    }
}
