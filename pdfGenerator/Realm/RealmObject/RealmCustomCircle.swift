////
////  RealmCustomCircle.swift
////  pdfConverter
////
////  Created by 二木裕也 on 2025/04/07.
////
//
//import SwiftUI
//import RealmSwift
//
//class RealmCustomCircle: Object {
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var showSelf: Bool
//    @Persisted var positionRateWidth: Double
//    @Persisted var positionRateHeight: Double
//    @Persisted var size: Double
//}
//
//extension RealmCustomCircle {
//    
//    func convertToNonRealm() -> CustomCircle {
//        return CustomCircle(id: self.id.stringValue,
//                            showSelf: self.showSelf,
//                            positionRate: CGSize(width: positionRateWidth,
//                                                 height: positionRateHeight),
//                            size: CGFloat(self.size))
//    }
//}
