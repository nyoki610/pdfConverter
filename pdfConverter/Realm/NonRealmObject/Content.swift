import SwiftUI
import RealmSwift
import UIKit


struct Content: Identifiable {
    let id: String
    let img: UIImage
    var title: String
    var detail: String
    
    init(id: String, img: Data, title: String, detail: String) {
        self.id = id
        self.img = img.toUIImage()
        self.title = title
        self.detail = detail
    }
    
    func convertToRealm() -> RealmContent {
        let realmContent = RealmContent()
        realmContent.img = img.toJPEGData()
        realmContent.title = title
        realmContent.detail = detail
        return realmContent
    }
}

extension Content {
    
    func updateSelf(
        realm: Realm?,
        img: UIImage? = nil,
        title: String? = nil,
        detail: String? = nil
    ) {
        guard let realm = realm else {
            print("Error: Realm instance not found.")
            return
        }

        guard let objectId = try? ObjectId(string: self.id) else {
            print("Error: Invalid ObjectId string for id: \(self.id).")
            return
        }

        guard let content = realm.object(ofType: RealmContent.self, forPrimaryKey: objectId) else {
            print("Error: Content with specified id \(self.id) not found.")
            return
        }

        do {
            try realm.write {
                if let title = title {
                    content.title = title
                    print("title has been updated")
                }
                if let img = img {
                    content.img = img.toJPEGData()
                }
                if let detail = detail {
                    content.detail = detail
                }
            }
            print("Log: Content updated successfully.")
        } catch {
            print("Error: Failed to update content - \(error.localizedDescription)")
        }
    }
}


//extension Image {
//    /// `Image` を `Data` に変換
//    func toData(compressionQuality: CGFloat = 1.0) -> Data? {
//        guard let uiImage = self.toUIImage() else { return nil }
//        return uiImage.jpegData(compressionQuality: compressionQuality) // JPEG形式
//    }
//
//    /// `Image` を `UIImage` に変換
//    func toUIImage() -> UIImage? {
//        let controller = UIHostingController(rootView: self)
//        let view = controller.view
//
//        let size = view?.intrinsicContentSize ?? CGSize(width: 100, height: 100)
//        let renderer = UIGraphicsImageRenderer(size: size)
//
//        return renderer.image { _ in
//            view?.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
//        }
//    }
//}



extension UIImage {
    /// JPEG形式でDataに変換
    func toJPEGData(quality: CGFloat = 0.8) -> Data {
        return self.jpegData(compressionQuality: quality) ?? Data()
    }
    
    /// PNG形式でDataに変換
    func toPNGData() -> Data? {
        return self.pngData()
    }

    func toSwiftUIImage() -> Image {
        return Image(uiImage: self)
    }
}


extension Data {
    /// DataからUIImageに変換
    func toUIImage() -> UIImage {
        return UIImage(data: self) ?? UIImage()
    }
}
