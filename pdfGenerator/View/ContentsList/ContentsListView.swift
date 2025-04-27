import PhotosUI
import SwiftUI


struct ContentsListView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType
    
    @StateObject var photoHandler = PhotoHandler()
    @EnvironmentObject var sharedData: SharedData
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @State private var showShuffleSheet: Bool = false
    @State private var selectedContentId: String = ""
    @State private var showImageEditorView: Bool = false

    var body: some View {
        
        ZStack {
            
            ScrollViewReader { proxy in
                VStack {
                    ScrollView {
                        
                        coverPageView
                        
                        ForEach(realmService.selectedProject.contents) { content in
                            ContentView(contentId: content.id,
                                        selectedContentId: $selectedContentId,
                                        showImageEditorView: $showImageEditorView)
                                .padding(.top, 10)
                                .padding(.horizontal, 40)
                                .id(content.id)
                        }
                        /// 十分下までスクロールできるように透明のアイテムを追加
                        Color.clear
                            .frame(width: 100, height: 80)
                    }
                    
                    HStack {
                        
                        Spacer()
                        
                        if !realmService.selectedProject.contents.isEmpty {
                            Button {
                                showShuffleSheet = true
                            } label: {
                                bottomButtonLabel(label: "並び替え", systemName: "shuffle")
                            }
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $photoHandler.selectedItems, matching: .images) {
                            bottomButtonLabel(label: "写真を追加", systemName: "rectangle.stack.fill.badge.plus")
                        }
                        .onChange(of: photoHandler.selectedItems) {
                            photosButtonAction()
                        }
                        
                        Spacer()

                        if !realmService.selectedProject.contents.isEmpty {
                            Button {
                                pdfButtonAction()
                            } label: {
                                bottomButtonLabel(label: "PDFを出力", systemName: "doc.fill")
                            }
                        }
                        
                        Spacer()

                    }
                    .padding(.vertical, 20)
                    .background(.white)
                }
            }

            if realmService.selectedProject.contents.isEmpty && realmService.selectedProject.coverPage == nil {
                VStack {
                    Text("写真が登録されていません")
                    Text("写真を追加してください")
                }
                .font(.system(size: responsiveSize(20, 24)))
                .fontWeight(.bold)
                .foregroundColor(.gray)
            }
            
            if showImageEditorView {
                Background()
                ImageEditorView(contentId: selectedContentId,
                                showImageEditorView: $showImageEditorView)
            }
        }
        /// ImageEditorView 表示時のみ Back ボタンを非表示にする
        .navigationBarBackButtonHidden(showImageEditorView)
        .ignoresSafeArea(.keyboard)
        .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.3))
        .sheet(isPresented: $showShuffleSheet) {
            ShuffleView(showShuffleSheet: $showShuffleSheet)
        }
    }
    
    @ViewBuilder
    private func bottomButtonLabel(label: String, systemName: String) -> some View {
        
        VStack {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: responsiveSize(30, 52), height: responsiveSize(30, 52))
                .padding(10)
                .background(.green.opacity(0.1))
                .clipShape(Circle())
            
            Text(label)
                .font(.system(size: responsiveSize(18, 22)))
        }
        .foregroundColor(.green)
        .fontWeight(.bold)
    }
}
