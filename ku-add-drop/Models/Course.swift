//
//  Course.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Course: Codable {
    var courseName: String
    var totalScore: Int
    var totalRateAmount: Int
    var commentsList: [Comment]
    var instList: [DocumentReference]
    
    enum CodingKeys: String, CodingKey {
        case courseName
        case totalScore
        case totalRateAmount
        case commentsList
        case instList
    }
}
