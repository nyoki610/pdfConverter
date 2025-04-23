import SwiftUI
import RealmSwift
import UIKit


struct Content: Identifiable {
    let id: String
    let image: UIImage
    var title: String
    var detail: String
    
    var customImage: UIImage?
    
    var pdfImage: UIImage { customImage ?? image }
    
    init(id: String, image: UIImage, title: String, detail: String, customImage: UIImage?) {
        self.id = id
        self.image = image
        self.title = title
        self.detail = detail
        self.customImage = customImage
    }
    
    func convertToRealm() -> RealmContent {
        let realmContent = RealmContent()
        realmContent.image = image.toJPEGData()
        realmContent.title = title
        realmContent.detail = detail
        realmContent.customImage = customImage?.toJPEGData()
        
        return realmContent
    }
}

extension Content {
    
    func updateSelf(
        realm: Realm?,
        image: UIImage? = nil,
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
                }
                if let image = image {
                    content.image = image.toJPEGData()
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
    
    func updateCustomImage(realm: Realm?, customImage: UIImage?) {
        
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
                content.customImage = customImage?.toJPEGData()
            }
            print("Log: Content updated successfully.")
        } catch {
            print("Error: Failed to update content - \(error.localizedDescription)")
        }
    }
}


extension Content {
    
    static let empty: Content = Content(id: "", image: UIImage(), title: "", detail: "", customImage: UIImage())
}
