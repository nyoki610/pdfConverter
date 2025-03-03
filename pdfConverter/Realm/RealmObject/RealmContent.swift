import Foundation
import RealmSwift

class RealmContent: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var img: Data
    @Persisted var title: String
    @Persisted var detail: String
}

extension RealmContent {
    
    func convertToNonRealm() -> Content {
        return Content(id: self.id.stringValue,
                       img: self.img,
                       title: self.title,
                       detail: self.detail
        )
    }
}
