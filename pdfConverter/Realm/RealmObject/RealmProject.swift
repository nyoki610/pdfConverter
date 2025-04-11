import Foundation
import RealmSwift

class RealmProject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var createdDate: Date
    @Persisted var lastUsedDate: Date
    @Persisted var coverPage: Data?
    @Persisted var contents: List<RealmContent>
}

extension RealmProject {
    
    func convertToNonRealm() -> Project {
        return Project(id: self.id.stringValue,
                       title: self.title,
                       createdDate: self.createdDate,
                       lastUsedDate: self.lastUsedDate,
                       coverPage: self.coverPage?.toUIImage(),
                       contents: contents.map {$0.convertToNonRealm()}
        )
    }
}
