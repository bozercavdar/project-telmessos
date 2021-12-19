//
//  Course.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import Foundation

struct Course: Codable {
    let courseId: String
    let courseName: String
    let totalScore: Int
    let totalRateAmount: Int
    let instructorsList: [String]
    let commentsList: [String]
}
