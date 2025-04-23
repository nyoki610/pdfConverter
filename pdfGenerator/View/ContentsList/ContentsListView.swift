import PhotosUI
import SwiftUI


struct ContentsListView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType
    
    @StateObject private var photoHandler = PhotoHandler()
    @EnvironmentObject private var sharedData: SharedData
    @EnvironmentObject private var realmService: RealmService
    @EnvironmentObject private var alertSharedData: AlertSharedData
    
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
                            
                            guard !photoHandler.selectedItems.isEmpty else { return }
                            
                            let scrollTargetIndex = realmService.selectedProject.contents.count

                            photoHandler.addContents(
                                project: realmService.selectedProject,
                                realm: realmService.realm
                            ) {
                                if scrollTargetIndex < realmService.selectedProject.contents.count {
                                    let scrollTargetId = realmService.selectedProject.contents[scrollTargetIndex].id
                                    withAnimation {
                                        proxy.scrollTo(scrollTargetId, anchor: .center)
                                    }
                                }
                            }
                        }
                        
                        Spacer()

                        if !realmService.selectedProject.contents.isEmpty {
                            Button {
                                PDFGenerator.savePDF(from: realmService.selectedProject) { success in
                                    if success {
                                        sharedData.path.append(.pdfViewer)
                                    } else {
                                        alertSharedData.showSingleAlert(title: "エラー",
                                                                        message: "PDFの生成に失敗しました",
                                                                        closeAction: {})
                                    }
                                }
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
    private var coverPageView: some View {
        
        if let coverPage = realmService.selectedProject.coverPage {
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    VStack {
                        Text("表紙")
                            .fontWeight(.bold)
                            .font(.system(size: responsiveSize(18, 24)))
                    }
                    .padding(.vertical, 4)
                    .frame(width: responsiveSize(48, 60))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black.opacity(0.3), lineWidth: 2)
                    )
                    
                    Spacer()
                    
                    DeleteButton {
                        alertSharedData.showSelectiveAlert(title: "表紙をリセット",
                                                           message: "この操作は取り消せません",
                                                           closeAction: {},
                                                           rightButtonLabel: "リセット",
                                                           rightButtonType: .destructive,
                                                           rightButtonAction: {
                            realmService.selectedProject.resetCoverPage(realm: realmService.realm)
                        })
                    }
                }
                .padding(.bottom, 20)
                
                ImageFrame {
                    Image(uiImage: coverPage.resizedToFit(CGSize: deviceType.photoSize))
                }
                .padding(.bottom, 10)
                
                PhotosPicker(selection: $photoHandler.selectedCoverPage,
                             maxSelectionCount: 1,
                             matching: .images) {
                    VStack {
                        TLButton(systemName: "rectangle.fill.badge.plus",
                                 label: "表紙ページを変更",
                                 color: .blue,
                                 verticalPadding: .fixed(nil),
                                 horizontalPadding: .fixed(nil)) {
                            
                        }
                                 .allowsHitTesting(false)
                    }
                    .padding(.horizontal, 20)
                }
                             .onChange(of: photoHandler.selectedCoverPage) {
                                 photoHandler.addCoverPage(project: realmService.selectedProject, realm: realmService.realm)
                             }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black.opacity(0.3), lineWidth: 2)
            )
            .padding(10)
        } else {
            
            PhotosPicker(selection: $photoHandler.selectedCoverPage,
                         maxSelectionCount: 1,
                         matching: .images) {
                VStack {
                    Image(systemName: "plus")
                        .bold()
                        .font(.system(size: 24))
                        .padding(.bottom, 4)
                    Text("表紙ページを追加する")
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 40)
                .background(.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.black.opacity(0.3), lineWidth: 2)
                )
                .padding(.top, 40)
                .padding(.bottom, 10)
                .padding(.horizontal, 30)
            }
                         .onChange(of: photoHandler.selectedCoverPage) {
                             photoHandler.addCoverPage(project: realmService.selectedProject, realm: realmService.realm)
                         }
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
