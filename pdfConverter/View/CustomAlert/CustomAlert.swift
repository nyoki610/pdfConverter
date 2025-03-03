import SwiftUI

struct CustomAlert: View {
    
    @EnvironmentObject private var alertSharedData: AlertSharedData

    let alertTitle: String
    let label: String
    @Binding var userInput: String
    @Binding var showCustomAlert: Bool
    let action: () -> Void
    
    @FocusState private var focusState: Bool
    
    init(alertTitle: String,
         label: String,
         userInput: Binding<String>,
         showCustomAlert: Binding<Bool>,
         action: @escaping () -> Void) {

        self.alertTitle = alertTitle
        self.label = label
        _userInput = userInput
        _showCustomAlert = showCustomAlert
        self.action = action
    }
    
    var body: some View {
        
        VStack {
            
            Text(alertTitle)
                .padding(.top, 20)
                .fontWeight(.medium)
            
            VStack {
                TextField(label, text: $userInput)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .focused($focusState)
                    .padding(4)
            }
            .frame(width: 200)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96, opacity: 1.0))
            .cornerRadius(4)
            .padding()
            
            HStack(spacing: 0) {
                
                Button {
                    showCustomAlert = false
                    userInput = ""
                } label: {
                    HStack {
                        Text("キャンセル")
                    }
                    .frame(width: 120, height: 40)
                    .overlay(
                        VStack {
                            Spacer()
                            Rectangle()
                                .frame(width: 0.5, height: 48)
                                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1))
                        },
                        alignment: .trailing
                    )
                }
                
                Button {
                    completeAction()
                } label: {
                    HStack {
                        Text("完了")
                    }
                    .frame(width: 120, height: 40)
                }
            }
            .frame(height: 40)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1)),
                alignment: .top
            )
            
        }
        .background(.white)
        .cornerRadius(8)
        .font(.system(size: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1), lineWidth: 0.5)
        )
        .onAppear {
            focusState = true
        }
    }
    
    private func completeAction() -> Void {
        
        focusState = false
        
        guard !userInput.isEmpty else {
            alertSharedData.showSingleAlert(
                title: "入力欄が空になっています",
                message: "",
                closeAction: {})
            return
        }
        
        showCustomAlert = false
        action()
        userInput = ""
    }
}
