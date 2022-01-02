//
//  Comment.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import Foundation

struct Comment: Codable {
    let courseName: String
    let owner: String
    let content: String
    let courseScore: Int
    
    enum CodingKeys: String, CodingKey {
        case courseName
        case owner
        case content
        case courseScore
    }
}

