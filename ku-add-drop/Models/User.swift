//
//  User.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import Foundation

struct User: Codable {
    let userId: String
    let userName: String
    let userSurname: String
    let userEmail: String
    let imageName: String
    let takenCoursesList: [String]

    enum CodingKeys: String, CodingKey {
        case userId
        case userName
        case userSurname
        case userEmail
        case imageName
        case takenCoursesList
    }
}
