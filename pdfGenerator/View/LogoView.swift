import SwiftUI

extension MainView {
    
    /// アプリ起動時に表示されるタイトル画面
    var logoView: some View {
        
        VStack {
                
            Spacer()
            
            Image("buildings")
                .resizable()
                .frame(width: 240, height: 240)
                .padding(.bottom, 40)
            Text("現場レポ")
                .font(.system(size: responsiveScaled(48, 1.5)))
            
            Spacer()
        }
        .foregroundColor(.white)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity)
        .background(.blue)
    }
}
