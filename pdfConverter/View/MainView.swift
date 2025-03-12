//
//  MainView.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/02.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var realmService = RealmService()
    @ObservedObject private var sharedData = SharedData()
    @ObservedObject private var alertSharedData = AlertSharedData()
    
    @ObservedObject private var customAlertHandler = CustomAlertHandler()
    
    var body: some View {
        
        ZStack {
            
            ProjectsListView()
            //TestView()
                .environmentObject(sharedData)
                .environmentObject(realmService)
                .environmentObject(customAlertHandler)
            
            if customAlertHandler.showCustomAlert {
                
                Background()
                
                VStack {
                    
                    Spacer()
                    
                    CustomAlert(alertTitle: customAlertHandler.alertTitle,
                                label: customAlertHandler.label,
                                userInput: $customAlertHandler.userInput,
                                showCustomAlert: $customAlertHandler.showCustomAlert,
                                action: customAlertHandler.action)
                    
                    Spacer()
                    Spacer()
                }
            }
        }
        .environmentObject(alertSharedData)
        .ignoresSafeArea(.keyboard)
        .alert(item: $alertSharedData.alertType) { _ in
            alertSharedData.createAlert()
        }
    }
}

