//
//  Comment.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import Foundation

struct Comment: Codable {
    let commentId: String
    let courseName: String
    let ownerEmail: String
    let content: String
    let courseScore: Int
}
