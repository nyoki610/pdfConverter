import SwiftUI
import RealmSwift
import UIKit


struct Content: Identifiable {
    let id: String
    let image: UIImage
    var issue: String
    var repairContent: String
    
    var customImage: UIImage?
    
    var pdfImage: UIImage { customImage ?? image }
    
    init(id: String, image: UIImage, issue: String, repairContent: String, customImage: UIImage?) {
        self.id = id
        self.image = image
        self.issue = issue
        self.repairContent = repairContent
        self.customImage = customImage
    }
    
    func convertToRealm() -> RealmContent {
        let realmContent = RealmContent()
        realmContent.image = image.toJPEGData()
        realmContent.issue = issue
        realmContent.repairContent = repairContent
        realmContent.customImage = customImage?.toJPEGData()
        
        return realmContent
    }
}

extension Content {
    
    func updateSelf(
        realm: Realm?,
        image: UIImage? = nil,
        issue: String? = nil,
        repairContent: String? = nil
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
                if let issue = issue {
                    content.issue = issue
                }
                if let image = image {
                    content.image = image.toJPEGData()
                }
                if let repairContent = repairContent {
                    content.repairContent = repairContent
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
