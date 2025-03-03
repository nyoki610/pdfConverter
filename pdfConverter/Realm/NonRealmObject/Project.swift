import Foundation
import RealmSwift

struct Project: Identifiable {
    
    let id: String
    let title: String
    let createdDate: Date
    let lastUsedDate: Date
    let contents: [Content]
    
    func convertToRealm() -> RealmProject {
        let realmProject = RealmProject()
        realmProject.title = title
        realmProject.createdDate = createdDate
        realmProject.lastUsedDate = lastUsedDate
        
        let realmContents = List<RealmContent>()
        for element in contents {
            let realmContent = element.convertToRealm()
            realmContents.append(realmContent)
        }
        realmProject.contents = realmContents

        return realmProject
    }
}

extension Project {
    
    func updateSelf(realm: Realm?, title: String? = nil, lastUsedDate: Date? = nil, add newContents: [Content]? = nil, delete targetContent: Content? = nil) {
        guard let realm = realm,
              let objectId = try? ObjectId(string: self.id),
              let project = realm.object(ofType: RealmProject.self, forPrimaryKey: objectId) else {
            print("\(self.id)")
            print("Error: Project with specified id not found."); return
        }

        do {
            try realm.write {
                if let newTitle = title {
                    project.title = newTitle
                }
                if let newLastUsedDate = lastUsedDate {
                    project.lastUsedDate = newLastUsedDate
                }
                if let newContents = newContents {
                    project.contents.append(objectsIn: newContents.map { $0.convertToRealm() })
                }
                if let targetId = targetContent?.id {
                    if let contentToRemove = project.contents.first(where: { $0.id.stringValue == targetId }) {
                        realm.delete(contentToRemove)
                    }
                }
            }
            print("Log: Project updated successfully.")
        } catch {
            print("Error: Failed to update project - \(error.localizedDescription)")
        }
    }
    
    func deleteSelf(realm: Realm?) {
        guard let realm = realm,
              let objectId = try? ObjectId(string: id),
              let project = realm.object(ofType: RealmProject.self, forPrimaryKey: objectId) else {
            print("Error: Project with specified id not found.")
            return
        }

        do {
            try realm.write {
                realm.delete(project)
            }
            print("Log: Project deleted successfully.")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

}
