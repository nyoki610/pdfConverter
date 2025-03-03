//
//  AlertHandler.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/02.
//

import SwiftUI

class CustomAlertHandler: ObservableObject {
    
    var alertTitle: String = ""
    var label: String = ""
    @Published var userInput: String = ""
    @Published var showCustomAlert: Bool = false
    var action: () -> Void = {}
    
    func controllCustomAlert(alertTitle: String, label: String, action: @escaping () -> Void) -> Void {
        
        DispatchQueue.main.async {
            self.alertTitle = alertTitle
            self.label = label
            self.action = action
            withAnimation(.easeIn(duration: 0.2)) {
                self.showCustomAlert = true
            }
        }
    }
}
