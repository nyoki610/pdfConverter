//
//  AlertSharedData.swift
//  pdfConverter
//
//  Created by 二木裕也 on 2025/03/02.
//

import SwiftUI

 
class AlertSharedData: ObservableObject {
    
    /// alert 表示時に引数として受け取る
    @Published var alertType: AlertType?
    private var title: String = ""
    private var message: String = ""
    ///

    private var closeAction: () -> Void = {}
    
    /// showSelectiveAlert 使用時に引数として受け取る
    var rightButtonLabel: String = ""
    private var rightButtonType: RightButtonType = .defaultButton
    var rightButtonAction: () -> Void = {}
    ///
    
    ///  just to be sure
    private func initializeProperties() -> Void {
        
        self.title = ""
        self.message = ""
        self.closeAction = {}
        
        self.rightButtonType = .defaultButton
        self.rightButtonLabel = ""
        self.rightButtonAction = {}
    }
    
    func showSingleAlert(
        title: String,
        message: String,
        closeAction: @escaping () -> Void
    ) {
        DispatchQueue.main.async {
            self.title = title
            self.message = message
            self.closeAction = closeAction
            self.alertType = .single
        }
    }
    
    func showSelectiveAlert(
        title: String,
        message: String,
        closeAction: @escaping () -> Void,
        rightButtonLabel: String,
        rightButtonType: RightButtonType,
        rightButtonAction: @escaping () -> Void
    ) {
        
        DispatchQueue.main.async {
            self.title = title
            self.message = message
            self.closeAction = closeAction
            self.rightButtonLabel = rightButtonLabel
            self.rightButtonType = rightButtonType
            self.rightButtonAction = rightButtonAction
            self.alertType = .selective
        }
    }
    
    func createAlert() -> Alert {
        
        switch self.alertType {
            
        case .single:
            return Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text("閉じる")) {
                    self.closeAction()
                    self.initializeProperties()
                }
            )
            
        case .selective:
            let primaryButton: Alert.Button = Alert.Button.default(Text("キャンセル")) {
                self.closeAction()
                self.initializeProperties()
            }
            
            return Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: primaryButton,
                secondaryButton: createSecondaryButton
            )
            
        default:
            return Alert(
                title: Text(""),
                message: Text(""),
                dismissButton: .default(Text("閉じる")) {
                    self.initializeProperties()
                }
            )
        }
    }
    
    private var createSecondaryButton: Alert.Button {
        
        switch self.rightButtonType {
            
        case .defaultButton:
            return .default(Text(rightButtonLabel)) {
                self.rightButtonAction()
                self.initializeProperties()
            }
            
        case .destructive:
            return .destructive(Text(rightButtonLabel)) {
                self.rightButtonAction()
                self.initializeProperties()
            }
        }
    }
}


extension AlertSharedData {
    
    enum AlertType: String, Identifiable {
        var id: String { self.rawValue }
        case single
        case selective
    }
    enum RightButtonType {
        case defaultButton
        case destructive
    }
}
