import Foundation
import RealmSwift

class RealmContent: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var image: Data
    @Persisted var title: String
    @Persisted var detail: String
    @Persisted var customImage: Data?
}

extension RealmContent {
    
    func convertToNonRealm() -> Content {
        return Content(id: self.id.stringValue,
                       image: self.image.toUIImage(),
                       title: self.title,
                       detail: self.detail,
                       customImage: self.customImage?.toUIImage()
        )
    }
}
