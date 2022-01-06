//
//  CourseDataSource.swift
//  ku-add-drop
//
//  Created by Lab on 6.01.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class CourseDataSource {
    let db = Firestore.firestore()
    var delegate : InstructorDataSourceDelegate?
    let user = FirebaseAuth.Auth.auth().currentUser
    var instructorDataSource = InstructorDataSource()
    var commentDataSource = CommentDataSource()
    
    init() {
        
    }
    
    func updateElement(collection: String, documentId: String, courseName: String, instructorName: String, commentContent: String, courseRating: Int, instructorRating: Int) {
        var courseObject = Course(courseName: courseName, totalScore: 0, totalRateAmount: 0, commentsList:[], instList: [])
        var ownerID = ""
        let docRef = db.collection(collection).document(documentId)
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Course.self)
            }
            switch result {
            case .success(let course):
                if let course = course {
                    //retrieve previos information about the course
                    courseObject.courseName = course.courseName
                    courseObject.totalScore = course.totalScore
                    courseObject.totalRateAmount = course.totalRateAmount
                    courseObject.commentsList = course.commentsList
                    courseObject.instList = course.instList
                    print("---------------------Course: \(courseObject)")
                    
                    self.addCourseHelper(collection: collection, documentId: documentId, courseName: courseName, instructorName: instructorName, commentContent: commentContent, courseRating: courseRating, instructorRating: instructorRating, ownerID: &ownerID, courseObject: &courseObject)
                } else {
                    self.addCourseHelper(collection: collection, documentId: documentId, courseName: courseName, instructorName: instructorName, commentContent: commentContent, courseRating: courseRating, instructorRating: instructorRating, ownerID: &ownerID, courseObject: &courseObject)
                }
            case .failure(let error):
                // A `Course` value could not be initialized from the DocumentSnapshot.
                print("-------------------Error decoding course: \(error)")
            }
        }


    }
    
    func addCourseHelper(collection: String, documentId: String, courseName: String, instructorName: String, commentContent: String, courseRating: Int, instructorRating: Int, ownerID: inout String, courseObject: inout Course){
        //add the instructor to instructor collection
        self.instructorDataSource.updatedAddInstructor(collection: "instructors", documentId: instructorName, name: instructorName, inputScore: instructorRating)
        //add comment to comment collection
        if let user = self.user{
            ownerID = user.email!
            self.commentDataSource.updatedAddComment(collection: "comments", owner: ownerID, courseName: courseName, content: commentContent, courseScore: courseRating)
        }
        // A nil value was successfully initialized from the DocumentSnapshot,
        // or the DocumentSnapshot was nil.
        print("--------------------Document does not exist")
        
        //add corresponding instructor reference to the object
        let instRef = self.db.collection("instructors").document(instructorName)
        var ifExists = false
        for ref in courseObject.instList{
            if ref.path == instRef.path{
                ifExists = true
            }
        }
        if(!ifExists){
            courseObject.instList.append(instRef)
        }
        
        //add corresponding comment reference to the object
        let commentHeader = ownerID + "-" + courseName
        let commentRef = self.db.collection("comments").document(commentHeader)
        var ifExistsComment = false
        for ref in courseObject.commentsList{
            if ref.path == commentRef.path{
                ifExistsComment = true
            }
        }
        if(!ifExistsComment){
            courseObject.commentsList.append(commentRef)
        }
        
        //update course fields accordingly
        courseObject.totalRateAmount += 1
        courseObject.totalScore += courseRating
        
        //update course object in the course collection
        do {
            try self.db.collection(collection).document(documentId).setData(from: courseObject)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    
}