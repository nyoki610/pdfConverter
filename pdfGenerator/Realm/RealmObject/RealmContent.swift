import Foundation
import RealmSwift

class RealmContent: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var image: Data
    @Persisted var issue: String
    @Persisted var repairContent: String
    @Persisted var customImage: Data?
}

extension RealmContent {
    
    func convertToNonRealm() -> Content {
        return Content(id: self.id.stringValue,
                       image: self.image.toUIImage(),
                       issue: self.issue,
                       repairContent: self.repairContent,
                       customImage: self.customImage?.toUIImage()
        )
    }
}
