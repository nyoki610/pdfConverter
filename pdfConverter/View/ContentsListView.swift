import PhotosUI
import SwiftUI


struct ContentsListView: View {
    
    @StateObject private var photoHandler = PhotoHandler()
    @EnvironmentObject private var realmService: RealmService
    @EnvironmentObject private var alertSharedData: AlertSharedData
    
    @State private var showSheet: Bool = false

    var body: some View {
        ZStack {
            
            ScrollView {
                ForEach(realmService.selectedProject.contents) { content in
                    contentView(content: content)
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
        .sheet(isPresented: $showSheet) {
            HalfModalView(isPresented: $showSheet)
                .presentationDetents([.medium])
        }
        .ignoresSafeArea(.keyboard)
        .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.3))
    }
    
    @ViewBuilder
    private func contentView(content: Content) -> some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Spacer()
                Button {
                    alertSharedData.showSelectiveAlert(
                        title: "写真を削除",
                        message: "この操作は取り消せません",
                        closeAction: {},
                        rightButtonLabel: "削除",
                        rightButtonType: AlertSharedData.RightButtonType.destructive,
                        rightButtonAction: {
                            realmService.selectedProject.updateSelf(
                                realm: realmService.realm,
                                delete: content
                            )
                        })
                } label: {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("削除")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                }
                .buttonStyle(.automatic)
            }
            .padding(.bottom, 20)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(uiImage: content.img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 160)
                    Spacer()
                }
                Spacer()
            }
            .frame(width: 300, height: 160)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.black.opacity(0.3), lineWidth: 2)
            )
            .padding(.bottom, 4)
            
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "pencil.line")
                        Text("画像を編集")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
                }
            }
            .padding(.bottom, 10)
            
            HStack {
                Text("詳細")
                Spacer()
            }

            CustomTextField(content: content, inputType: .title)
            .padding(.bottom, 4)
            
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("過去の入力内容をコピー")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
                }
            }
            .padding(.bottom, 16)
            
            HStack {
                Text("修繕内容")
                Spacer()
            }
            
            CustomTextField(content: content, inputType: .detail)
            .padding(.bottom, 4)
            
            HStack {
                Spacer()
                Button {
                    showSheet = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("過去の入力内容をコピー")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
                }
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
    }
}


struct CustomTextField: View {
    @EnvironmentObject private var realmService: RealmService
    @State var userInput: String
    let content: Content
    let inputType: InputType
    @FocusState var isFocused: Bool
    
    enum InputType: String {
        case title = "詳細"
        case detail = "修繕内容"
    }
    
    init(content: Content, inputType: InputType) {
        self.userInput = (inputType == .title) ? content.title : content.detail
        self.content = content
        self.inputType = inputType
    }
    
    var body: some View {
        TextField("タップして\(inputType.rawValue)を入力", text: $userInput)
            .focused($isFocused)
            .onChange(of: isFocused) { _, newValue in
                print(isFocused)
                if !newValue {
                    content.updateSelf(
                        realm: realmService.realm,
                        title: (inputType == .title) ? userInput : nil,
                        detail: (inputType == .detail) ? userInput : nil
                    )
                }
            }
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.black.opacity(0.3), lineWidth: 2)
            )
    }
}

struct DetailEditor: View {
    @EnvironmentObject private var realmService: RealmService
    @State var detail: String
    let content: Content
    
    @FocusState var isFocused: Bool
    
    init(content: Content) {
        self.detail = content.detail
        self.content = content
    }
    
    var body: some View {
          TextEditor(text: $detail)
            .focused($isFocused)
            .autocorrectionDisabled(true)
            .frame(height: 60)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.black.opacity(0.3), lineWidth: 2)
            )
            .onChange(of: isFocused) { _, newValue in
                if !isFocused {
                    content.updateSelf(realm: realmService.realm, detail: self.detail)
                }
            }
    }
}

struct HalfModalView: View {
    @Binding var isPresented: Bool
    
    let textList: [Content] = [
        .init(id: "1", img: Data(), title: "アスファルトの劣化・捲れ", detail: ""),
        .init(id: "2", img: Data(), title: "シーリングの割れ", detail: ""),
        .init(id: "3", img: Data(), title: "ウレタン防水の透け", detail: ""),
        .init(id: "4", img: Data(), title: "金物への防水剤の付着", detail: ""),
    ]
    
    var body: some View {
        VStack {
            Text("過去の入力内容から選択")
                .fontWeight(.semibold)
                .font(.system(size: 18))
                .padding()
            
            ScrollView {
                ForEach(textList) { text in
                    Button {
                        
                    } label: {
                        Text(text.title).centered
                            .foregroundStyle(.black)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(4)
                    .padding(.horizontal, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
