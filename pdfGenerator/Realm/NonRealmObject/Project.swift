import SwiftUI
import RealmSwift

struct Project: Identifiable {
    
    let id: String
    var title: String
    let createdDate: Date
    let lastUsedDate: Date
    let coverPage: UIImage?
    let contents: [Content]
    
    func convertToRealm() -> RealmProject {
        let realmProject = RealmProject()
        realmProject.title = title
        realmProject.createdDate = createdDate
        realmProject.lastUsedDate = lastUsedDate
        
        let realmContents = RealmSwift.List<RealmContent>()
        for element in contents {
            let realmContent = element.convertToRealm()
            realmContents.append(realmContent)
        }
        realmProject.coverPage = coverPage?.toJPEGData()
        realmProject.contents = realmContents

        return realmProject
    }
}

extension Project {
    
    func updateSelf(
        realm: Realm?,
        title: String? = nil,
        lastUsedDate: Date? = nil,
        coverPage: Data? = nil,
        add newContents: [Content]? = nil,
        delete targetContent: Content? = nil
    ) {

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
                if let coverPage = coverPage {
                    project.coverPage = coverPage
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
    
    func resetCoverPage(realm: Realm?) {
        guard let realm = realm,
              let objectId = try? ObjectId(string: self.id),
              let project = realm.object(ofType: RealmProject.self, forPrimaryKey: objectId) else {
            print("\(self.id)")
            print("Error: Project with specified id not found."); return
        }

        do {
            try realm.write {
                project.coverPage = nil
            }
            print("Log: Project updated successfully.")
        } catch {
            print("Error: Failed to update project - \(error.localizedDescription)")
        }
    }
    
    func shuffleContents(realm: Realm?, contentIdList: [String]) {
        
        let shuffledContents: RealmSwift.List<RealmContent> = {
            let list = RealmSwift.List<RealmContent>()
            contentIdList.compactMap { id in
                self.contents.first { $0.id == id }?.convertToRealm()
            }.forEach { list.append($0) }
            return list
        }()
        
        guard shuffledContents.count == self.contents.count else { return }
        
        guard let realm = realm,
              let objectId = try? ObjectId(string: id),
              let project = realm.object(ofType: RealmProject.self, forPrimaryKey: objectId) else {
            print("Error: Project with specified id not found.")
            return
        }
        
        do {
            try realm.write {
                /// 並び替え前の contents の参照を取得
                let oldContents = project.contents
                /// 参照を切る
                project.contents.removeAll()
                /// oldContents を全削除
                realm.delete(oldContents)

                /// 並び替え後の contents を代入
                project.contents = shuffledContents
            }
            print("Log: Project deleted successfully.")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
