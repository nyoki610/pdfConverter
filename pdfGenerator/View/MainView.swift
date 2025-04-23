//
//  MainView.swift
//  pdfGenerator
//
//  Created by 二木裕也 on 2025/03/02.
//

import SwiftUI

struct MainView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @ObservedObject private var realmService = RealmService()
    @ObservedObject private var sharedData = SharedData()
    @ObservedObject private var alertSharedData = AlertSharedData()
    @ObservedObject private var customAlertHandler = CustomAlertHandler()
    
    @State private var showLogoView: Bool = true
    
    var body: some View {
        
        ZStack {
            
            if showLogoView {
                logoView
            } else {
                mainView
            }
        }
        .font(.system(size: responsiveSize(16, 24)))
        .environmentObject(alertSharedData)
        .ignoresSafeArea(.keyboard)
        .alert(item: $alertSharedData.alertType) { _ in
            alertSharedData.createAlert()
        }
        .onAppear {

            /// LogoView を 3 秒間表示した後, 画面遷移
            Task {
                do {
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    withAnimation {
                        showLogoView = false
                    }
                } catch { print("Error: \(error)") }
            }
        }
    }
    
    @ViewBuilder
    private var mainView: some View {
        
        ProjectsListView()
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
}

