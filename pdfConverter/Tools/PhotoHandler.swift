import PhotosUI
import SwiftUI
import RealmSwift

class PhotoHandler: ObservableObject {
    
    @Published var selectedItems: [PhotosPickerItem] = []
    
    // 非同期処理で画像を更新
    func addContents(project: Project, realm: Realm?) {
        
        // 非同期で画像を読み込む
        let group = DispatchGroup() // 複数の非同期処理を同期的に待機
        var newContents: [Content] = []

        for item in selectedItems {
            group.enter() // 処理開始
            
            item.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image?):
                        let newContent = Content(id: "", img: image, title: "", detail: "")
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
        }
    }
}
