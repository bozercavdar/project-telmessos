//
//  Comment.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import Foundation

struct Comment: Codable {
    var courseName: String
    var owner: String
    var content: String
    var courseScore: Int
    
    enum CodingKeys: String, CodingKey {
        case courseName
        case owner
        case content
        case courseScore
    }
}

