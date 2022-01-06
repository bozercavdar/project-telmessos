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
    var name: String
    var surname: String
    var email: String
    var imageName: String
    var takenCoursesList: [DocumentReference]

    enum CodingKeys: String, CodingKey {
        case name
        case surname
        case email
        case imageName
        case takenCoursesList
    }
}
