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
    var delegate : CourseDataSourceDelegate?
    let user = FirebaseAuth.Auth.auth().currentUser
    var instructorDataSource = InstructorDataSource()
    var commentDataSource = CommentDataSource()
    var userDataSource = UserDataSource()
    var courseObject : Course?
    
    init() {

    }
    
    func updateCourse(documentId: String, courseName: String, instructorName: String, commentContent: String, courseRating: Int, instructorRating: Int, completion: @escaping (String)->Void) {
        var courseObject = Course(courseName: courseName, totalScore: 0, totalRateAmount: 0, commentsList:[], instList: [])
        var ownerID = ""
        let docRef = db.collection("courses").document(documentId)
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
                    
                    self.addCourseHelper(documentId: documentId, courseName: courseName, instructorName: instructorName, commentContent: commentContent, courseRating: courseRating, instructorRating: instructorRating, ownerID: &ownerID, courseObject: &courseObject)
                    completion("------------ UpdateCourseComplete")
                } else {
                    print("--------------------Course does not exist. A new one is created")
                    self.addCourseHelper(documentId: documentId, courseName: courseName, instructorName: instructorName, commentContent: commentContent, courseRating: courseRating, instructorRating: instructorRating, ownerID: &ownerID, courseObject: &courseObject)
                    completion("------------ UpdateCourseComplete")
                }
                
            case .failure(let error):
                // A `Course` value could not be initialized from the DocumentSnapshot.
                print("-------------------Error decoding course: \(error)")
            }
        
        }

    }
    
    func addCourseHelper(documentId: String, courseName: String, instructorName: String, commentContent: String, courseRating: Int, instructorRating: Int, ownerID: inout String, courseObject: inout Course){
        //add the instructor to instructor collection
        self.instructorDataSource.updatedAddInstructor(documentId: instructorName, name: instructorName, inputScore: instructorRating)
        //add comment to comment collection
        if let user = self.user{
            ownerID = user.email!
            self.commentDataSource.updatedAddComment(owner: ownerID, courseName: courseName, content: commentContent, courseScore: courseRating)
        }
        //add course to user's takenCourses list
        self.userDataSource.addCourse(courseName: courseName)
        
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
           try self.db.collection("courses").document(documentId).setData(from: courseObject)

        } catch let error {
            print("Error writing course to Firestore: \(error)")
        }
    }
    
    func getCourseNameWithReference(docRef: DocumentReference ,completion: @escaping (String?)->Void) {
        docRef.getDocument(completion: { (document, error) in
            let result = Result {
              try document?.data(as: Course.self)
            }
            switch result {
            case .success(let course):
                if let course = course {
                    completion(course.courseName)
                } else {
                    //impossible case
                    print("-------------------Error")
                }
            case .failure(let error):
                // A `User` value could not be initialized from the DocumentSnapshot.
                print("-------------------Error decoding user: \(error)")
            }
        })
    }
    
   // for comments
    func getCommentNumber() -> Int {
        DispatchQueue.main.async {
            self.delegate?.commentCountLoaded()
        }
        if(courseObject != nil) {
             return courseObject!.commentsList.count
        }else{
            return 0
        }
    }
    
    func getCommentRefs() -> Array<DocumentReference>{
        DispatchQueue.main.async {
            self.delegate?.commentRefListLoaded()
        }
        if(courseObject != nil) {
            return courseObject!.commentsList
        }else{
            return []
        }
    }
    
    // for instructors
    func getInstructorNumber() -> Int {
        DispatchQueue.main.async {
            self.delegate?.instructorCountLoaded()
        }
        if(courseObject != nil) {
             return courseObject!.instList.count
        }else{
            return 0
        }
    }
    
    func getInstructorRefs() -> Array<DocumentReference>{
        DispatchQueue.main.async {
            self.delegate?.commentRefListLoaded()
        }
        if(courseObject != nil) {
            return courseObject!.instList
        }else{
            return []
        }
    }
    
    func getCourse(documentRef:String, completion: @escaping (Course) -> Void){
        let courseDocRef = db.collection("courses").document(documentRef)
        courseDocRef.getDocument(completion: { (document, error) in
            let result = Result {
              try document?.data(as: Course.self)
            }
            switch result {
            case .success(let course):
                if let course = course {
                    completion(course)
                } else {
                    //impossible case
                    print("-------------------Error")
                }
            case .failure(let error):
                // A `User` value could not be initialized from the DocumentSnapshot.
                print("-------------------Error decoding user: \(error)")
            }
        })
    }
    
    func reloadCourse(documentRef: String)  {
        getCourse(documentRef: documentRef, completion: {
            course in self.courseObject = course
            DispatchQueue.main.async {
                self.delegate?.courseLoaded()
            }
        })
    }
    
    func getCourseScore() -> Double {
    
        if(courseObject != nil) {
            let score = courseObject?.totalScore as! Int
            let rate = courseObject?.totalRateAmount as! Int
            let value = Double(score)/Double(rate)
            return round(value*10)/10.0
            
        }else{
            return 0
        }
        
        
    }
    
}
