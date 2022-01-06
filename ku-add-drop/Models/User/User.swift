//
//  User.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
    let name: String
    let surname: String
    let email: String
    let imageName: String
    let takenCoursesList: [DocumentReference]

    enum CodingKeys: String, CodingKey {
        case name
        case surname
        case email
        case imageName
        case takenCoursesList
    }
}
