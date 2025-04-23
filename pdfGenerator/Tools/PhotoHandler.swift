import PhotosUI
import SwiftUI
import RealmSwift

class PhotoHandler: ObservableObject {

    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedCoverPage: [PhotosPickerItem] = []
    
    func addContents(project: Project, realm: Realm?, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        var newContents: [Content?] = Array(repeating: nil, count: selectedItems.count)

        for (index, item) in selectedItems.enumerated() {
            group.enter()
            
            item.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image?):
                        let newContent = Content(id: UUID().uuidString,
                                                 image: image.toUIImage(),
                                                 title: "",
                                                 detail: "",
                                                 customImage: nil)
                        /// index を指定して更新 -> 元の順序を保つ
                        newContents[index] = newContent
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    default:
                        break
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            /// nil を除外
            let filteredContents = newContents.compactMap { $0 }
            project.updateSelf(realm: realm, add: filteredContents)
            self.selectedItems = []
            completion()
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
