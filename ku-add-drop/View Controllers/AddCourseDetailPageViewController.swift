//
//  AddCourseDetailPageViewController.swift
//  ku-add-drop
//
//  Created by Lab on 29.12.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class AddCourseDetailPageViewController: UIViewController {

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseRatingSlider: UISlider!
    @IBOutlet weak var instructorTextInput: UITextField!
    @IBOutlet weak var instructorRatingSlider: UISlider!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var courseRatingLabel: UILabel!
    @IBOutlet weak var instructorRatingLabel: UILabel!
    
    
    let db = Firestore.firestore()
    var addedCourseName: String?
    let user = FirebaseAuth.Auth.auth().currentUser
    var courseDataSource = CourseDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseNameLabel.text = addedCourseName!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func postAction(_ sender: Any) {
        let courseName = addedCourseName!
        let instructorName = instructorTextInput.text!
        let commentContent = commentTextView.text!
        let courseRating = round(courseRatingSlider.value * 10) / 10.0
        let instructorRating = round(instructorRatingSlider.value * 10) / 10.0

        courseDataSource.updateCourse(documentId: courseName, courseName: courseName, instructorName: instructorName, commentContent: commentContent, courseRating: Int(courseRating), instructorRating: Int(instructorRating))
        
        
    }
    
    
    @IBAction func courseSliderValueChanged(_ sender: UISlider) {
        let courseRating = Int(round(courseRatingSlider.value * 10) / 10.0)
        courseRatingLabel.text = "\(courseRating) ⭐️"

    }
    @IBAction func instructorSliderValueChanged(_ sender: UISlider) {
        let instructorRating = Int(round(instructorRatingSlider.value * 10) / 10.0)
        instructorRatingLabel.text = "\(instructorRating) ⭐️"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func updateElement(collection: String, documentId: String, courseName: String, instructorName: String, commentContent: String, courseRating: Int, instructorRating: Int) {
//        var courseObject = Course(courseName: courseName, totalScore: 0, totalRateAmount: 0, commentsList:[], instList: [])
//        var ownerID = ""
//        let docRef = db.collection(collection).document(documentId)
//        docRef.getDocument { (document, error) in
//            let result = Result {
//              try document?.data(as: Course.self)
//            }
//            switch result {
//            case .success(let course):
//                if let course = course {
//                    //add the instructor to instructor collection
//                    self.instructorDataSource.updatedAddInstructor(collection: "instructors", documentId: instructorName, name: instructorName, inputScore: instructorRating)
//                    //add comment to comment collection
//                    if let user = self.user{
//                        ownerID = user.email!
//                        self.commentDataSource.updatedAddComment(collection: "comments", owner: ownerID, courseName: courseName, content: commentContent, courseScore: courseRating)
//                    }
//                    //retrieve previos information about the course
//                    courseObject.courseName = course.courseName
//                    courseObject.totalScore = course.totalScore
//                    courseObject.totalRateAmount = course.totalRateAmount
//                    courseObject.commentsList = course.commentsList
//                    courseObject.instList = course.instList
//                    print("---------------------Course: \(courseObject)")
//
//                    //add corresponding instructor reference to the object
//                    let instRef = self.db.collection("instructors").document(instructorName)
//                    var ifExists = false
//                    for ref in courseObject.instList{
//                        if ref.path == instRef.path{
//                            ifExists = true
//                        }
//                    }
//                    if(!ifExists){
//                        courseObject.instList.append(instRef)
//                    }
//
//                    //add corresponding comment reference to the object
//                    let commentHeader = ownerID + "-" + courseName
//                    let commentRef = self.db.collection("comments").document(commentHeader)
//                    var ifExistsComment = false
//                    for ref in courseObject.commentsList{
//                        if ref.path == commentRef.path{
//                            ifExistsComment = true
//                        }
//                    }
//                    if(!ifExistsComment){
//                        courseObject.commentsList.append(commentRef)
//                    }
//
//                    //update course fields accordingly
//                    courseObject.totalRateAmount += 1
//                    courseObject.totalScore += courseRating
//
//                    //update course object in the course collection
//                    do {
//                        try self.db.collection(collection).document(documentId).setData(from: courseObject)
//                    } catch let error {
//                        print("Error writing city to Firestore: \(error)")
//                    }
//
//
//                } else {
//                    self.instructorDataSource.updatedAddInstructor(collection: "instructors", documentId: instructorName, name: instructorName, inputScore: instructorRating)
//                    if let user = self.user{
//                        ownerID = user.email!
//                        self.commentDataSource.updatedAddComment(collection: "comments", owner: ownerID, courseName: courseName, content: commentContent, courseScore: courseRating)
//                    }
//                    // A nil value was successfully initialized from the DocumentSnapshot,
//                    // or the DocumentSnapshot was nil.
//                    print("--------------------Document does not exist")
//
//                    let instRef = self.db.collection("instructors").document(instructorName)
//                    var ifExists = false
//                    for ref in courseObject.instList{
//                        if ref.path == instRef.path{
//                            ifExists = true
//                        }
//                    }
//                    if(!ifExists){
//                        courseObject.instList.append(instRef)
//                    }
//
//                    let commentHeader = ownerID + "-" + courseName
//                    let commentRef = self.db.collection("comments").document(commentHeader)
//                    var ifExistsComment = false
//                    for ref in courseObject.commentsList{
//                        if ref.path == commentRef.path{
//                            ifExistsComment = true
//                        }
//                    }
//                    if(!ifExistsComment){
//                        courseObject.commentsList.append(commentRef)
//                    }
//
//                    courseObject.totalRateAmount += 1
//                    courseObject.totalScore += courseRating
//
//
//
//                    do {
//                        try self.db.collection(collection).document(documentId).setData(from: courseObject)
//                    } catch let error {
//                        print("Error writing city to Firestore: \(error)")
//                    }
//                }
//            case .failure(let error):
//                // A `City` value could not be initialized from the DocumentSnapshot.
//                print("-------------------Error decoding course: \(error)")
//            }
//        }
//
//
//    }
        

    
    func readInstructorObject(docRef: DocumentReference){
        var instructorObject = Instructor(instructorName: "Burhan Özer", totalScore: 15, totalRateAmount: 3)
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Instructor.self)
                
            }
            switch result {
            case .success(let instructor):
                if let instructor = instructor {
                    instructorObject.instructorName = instructor.instructorName
                    instructorObject.totalScore = instructor.totalScore
                    instructorObject.totalRateAmount = instructor.totalRateAmount

                    print("---------------------Attila: \(instructorObject)")
                    
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("--------------------Document does not exist")
                    

                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("-------------------Error decoding course: \(error)")
            }
        }
    }
  
}
