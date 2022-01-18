//
//  CourseDataSourceDelegate.swift
//  ku-add-drop
//
//  Created by Lab on 6.01.2022.
//

import Foundation

protocol CourseDataSourceDelegate {
    func commentRefListLoaded()
    func commentCountLoaded()
    func courseLoaded()
    func instructorCountLoaded()

}
