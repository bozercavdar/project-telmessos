//
//  Instructor.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import Foundation

struct Instructor: Codable {
    let instructorId: String
    let instructorName: String
    let instructorSurname: String
    let totalScore: [String:Int]
    let totalRateAmount: [String:Int]
}
