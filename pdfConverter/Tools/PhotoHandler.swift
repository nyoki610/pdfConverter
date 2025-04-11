import PhotosUI
import SwiftUI
import RealmSwift

class PhotoHandler: ObservableObject {

    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedCoverPage: [PhotosPickerItem] = []
    
    func addContents(project: Project, realm: Realm?, completion: @escaping () -> Void) {
        // 非同期で画像を読み込む
        let group = DispatchGroup() // 複数の非同期処理を同期的に待機
        var newContents: [Content] = []

        for item in selectedItems {
            group.enter() // 処理開始
            
            item.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image?):
                        let newContent = Content(id: UUID().uuidString,
                                                 image: image.toUIImage(),
                                                 issue: "",
                                                 repairContent: "",
                                                 customImage: nil)
                        newContents.append(newContent)
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    default:
                        break
                    }
                    group.leave() // 処理完了
                }
            }
        }
        
        // すべての画像の読み込みが完了したらselectedImagesを更新
        group.notify(queue: .main) {
            project.updateSelf(realm: realm, add: newContents)
            self.selectedItems = []
            
            // 完了通知
            completion() // ここで外部に完了を通知
        }
    }
    
    func addCoverPage(project: Project, realm: Realm?) {
        
        guard selectedCoverPage.count == 1 else { print("the count does not match"); return }
        
        selectedCoverPage[0].loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image?):
                    project.updateSelf(realm: realm, coverPage: image)
                case .failure(let error):
                    print("Error loading image: \(error)")
                default:
                    break
                }
            }
        }
        
        selectedCoverPage = []
    }
}
