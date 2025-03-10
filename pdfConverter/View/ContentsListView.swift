import PhotosUI
import SwiftUI


struct ContentsListView: View {
    
    @StateObject private var photoHandler = PhotoHandler()
    @EnvironmentObject private var realmService: RealmService
    @EnvironmentObject private var alertSharedData: AlertSharedData
    
    var body: some View {
        
        ZStack {
            ScrollView {
                ForEach(realmService.selectedProject.contents) { content in
                    ContentView(content: content)
                        .padding(.top, 10)
                }
                
                Color.clear
                    .frame(width: 100, height: 80)
            }
            
            VStack {
                
                Spacer()
                
                HStack {
                    Spacer()
                    PhotosPicker(selection: $photoHandler.selectedItems, matching: .images) {
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                            Text("写真を追加")
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .background(.green)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: photoHandler.selectedItems) {
                        photoHandler.addContents(
                            project: realmService.selectedProject,
                            realm: realmService.realm
                        )
                    }
                    Spacer()
                }
                .background(.clear)
            }
            
            if realmService.selectedProject.contents.isEmpty {
                VStack {
                    Text("写真が登録されていません")
                    Text("写真を追加してください")
                }
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.gray)
            }
        }
        .ignoresSafeArea(.keyboard)
        .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.3))
    }
}
