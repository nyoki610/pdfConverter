////
////  Array.swift
////  pdfConverter
////
////  Created by 二木裕也 on 2025/03/11.
////
//
//import Foundation
//
//
//extension Array {
//    func chunked(into size: Int) -> [[Element]] {
//        return stride(from: 0, to: count, by: size).map {
//            Array(self[$0 ..< Swift.min($0 + size, count)])
//        }
//    }
//}
