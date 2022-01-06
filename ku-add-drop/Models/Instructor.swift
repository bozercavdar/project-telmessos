//
//  Instructor.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import Foundation

struct Instructor: Codable {
    var instructorName: String
    var totalScore: Int
    var totalRateAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case instructorName
        case totalScore
        case totalRateAmount
    }
}
