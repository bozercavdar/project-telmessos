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
        

        
        updateElement(collection: "courses", documentId: courseName, courseName: courseName, instructorName: instructorName, commentContent: commentContent, courseRating: Int(courseRating), instructorRating: Int(instructorRating))
//        //for courses
//        addName(collection: "courses", documentId: courseName, name: courseName)
//        addElement(collection: "courses", documentId: courseName, field: "instructors", toBeAdded: instructorName)
//        addElement(collection: "courses", documentId: courseName, field: "comments", toBeAdded: commentContent)
//        increaseField(collection: "courses", documentId: courseName, field: "totalRating", increaseAmount: Double(courseRating))
//        increaseField(collection: "courses", documentId: courseName, field: "voterAmount", increaseAmount: 1)
//
//        //for instructors
//        addName(collection: "instructors", documentId: instructorName, name: instructorName)
//        increaseField(collection: "instructors", documentId: instructorName, field: "totalRating", increaseAmount: Double(instructorRating))
//        increaseField(collection: "instructors", documentId: instructorName, field: "voterAmount", increaseAmount: 1)
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
                    self.updatedAddInstructor(collection: "instructors", documentId: instructorName, name: instructorName, inputScore: instructorRating)
                    if let user = self.user{
                        ownerID = user.email!
                        self.updatedAddComment(collection: "comments", owner: ownerID, courseName: courseName, content: commentContent, courseScore: courseRating)
                    }
                    courseObject.courseName = course.courseName
                    courseObject.totalScore = course.totalScore
                    courseObject.totalRateAmount = course.totalRateAmount
                    courseObject.commentsList = course.commentsList
                    courseObject.instList = course.instList
                    print("---------------------Course: \(courseObject)")
                    
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
                    
                    courseObject.totalRateAmount += 1
                    courseObject.totalScore += courseRating


                    do {
                        try self.db.collection(collection).document(documentId).setData(from: courseObject)
                    } catch let error {
                        print("Error writing city to Firestore: \(error)")
                    }


                } else {
                    self.updatedAddInstructor(collection: "instructors", documentId: instructorName, name: instructorName, inputScore: instructorRating)
                    if let user = self.user{
                        ownerID = user.email!
                        self.updatedAddComment(collection: "comments", owner: ownerID, courseName: courseName, content: commentContent, courseScore: courseRating)
                    }
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("--------------------Document does not exist")
                    
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
                    
                    courseObject.totalRateAmount += 1
                    courseObject.totalScore += courseRating



                    do {
                        try self.db.collection(collection).document(documentId).setData(from: courseObject)
                    } catch let error {
                        print("Error writing city to Firestore: \(error)")
                    }
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("-------------------Error decoding course: \(error)")
            }
        }


    }
    
    func updatedAddInstructor(collection: String, documentId: String, name: String, inputScore: Int){
        var instructorObject = Instructor(instructorName: name, totalScore: 0, totalRateAmount: 0)
        let docRef = db.collection(collection).document(documentId)
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Instructor.self)
            }
            switch result {
            case .success(let instructor):
                if let instructor = instructor {
                    
                    instructorObject.totalScore = instructor.totalScore
                    instructorObject.totalRateAmount = instructor.totalRateAmount
                    print("---------------------Instructor: \(instructorObject)")
                    
                    instructorObject.totalScore += inputScore
                    instructorObject.totalRateAmount += 1
                    
                    do {
                        try self.db.collection(collection).document(documentId).setData(from: instructorObject)
                    } catch let error {
                        print("Error writing city to Firestore: \(error)")
                    }
                } else {
                    print("--------------------Document does not exist")
                    
                    instructorObject.totalScore += inputScore
                    instructorObject.totalRateAmount += 1
                    do {
                        try self.db.collection(collection).document(documentId).setData(from: instructorObject)
                    } catch let error {
                        print("Error writing city to Firestore: \(error)")
                    }
                }
            case .failure(let error):

                print("-------------------Error decoding instructor: \(error)")
            }
        }
    }
    
    func updatedAddComment(collection: String, owner: String, courseName: String, content: String, courseScore: Int){
        var commentObject = Comment(courseName: "", owner: "", content: "", courseScore: 0)
        let documentId = owner + "-" + courseName
        let docRef = db.collection(collection).document(documentId)
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Comment.self)
            }
            switch result {
            case .success(let comment):
                if let comment = comment {
                    
                    commentObject.courseName = comment.courseName
                    commentObject.owner = comment.owner
                    commentObject.content = comment.content
                    commentObject.courseScore = comment.courseScore
                    print("---------------------Instructor: \(commentObject)")
                    
                    commentObject.content = content
                    commentObject.courseScore = courseScore
                    
                    do {
                        try self.db.collection(collection).document(documentId).setData(from: commentObject)
                    } catch let error {
                        print("Error writing city to Firestore: \(error)")
                    }
                } else {
                    print("--------------------Document does not exist")
                    
                    commentObject.owner = owner
                    commentObject.courseName = courseName
                    commentObject.content = content
                    commentObject.courseScore = courseScore
                    
                    do {
                        try self.db.collection(collection).document(documentId).setData(from: commentObject)
                    } catch let error {
                        print("Error writing city to Firestore: \(error)")
                    }
                }
            case .failure(let error):

                print("-------------------Error decoding instructor: \(error)")
            }
        }
    }
    
//    func playGroundForRef(){
//        var courseObject = Course(courseName: "", totalScore: 0, totalRateAmount: 0, instructorsList: [], commentsList:[], instList: [])
//        var instructorObject = Instructor(instructorName: "Burhan Özer", totalScore: 15, totalRateAmount: 3)
//        var commentObject = Comment(courseName: "COMP100", owner: "Murat Özer", content: "İyi", courseScore: 4)
//
//        //self.updatedAddInstructor(collection: "instructors", documentId: instructorName, name: instructorName, inputScore: instructorRating)
//
//        let docRef = db.collection("courses").document("COMP100")
//        docRef.getDocument { (document, error) in
//            let result = Result {
//              try document?.data(as: Course.self)
//
//            }
//            switch result {
//            case .success(let course):
//                if let course = course {
//                    // A `City` value was successfully initialized from the DocumentSnapshot.
//                    courseObject.courseName = course.courseName
//                    courseObject.totalScore = course.totalScore
//                    courseObject.totalRateAmount = course.totalRateAmount
//                    courseObject.instructorsList = course.instructorsList
//                    courseObject.commentsList = course.commentsList
//                    courseObject.instList = course.instList
//                    print("---------------------Course: \(courseObject)")
//
//                    let attilaRef = self.db.collection("instructors").document("Attila 3")
//                    var ifExists = false
//                    for ref in courseObject.instList{
//                        if ref.path == attilaRef.path{
//                            ifExists = true
//                        }
//                    }
//                    if(!ifExists){
//                        courseObject.instList.append(attilaRef)
//                    }
//
//                    courseObject.totalRateAmount += 1
//                    courseObject.totalScore += 5
//                    courseObject.instructorsList.append(instructorObject)
//                    courseObject.commentsList.append(commentObject)
//
//
//                    do {
//                        try self.db.collection("courses").document("COMP100").setData(from: courseObject)
//                    } catch let error {
//                        print("Error writing city to Firestore: \(error)")
//                    }
//
//
//                } else {
//                    // A nil value was successfully initialized from the DocumentSnapshot,
//                    // or the DocumentSnapshot was nil.
//                    print("--------------------Document does not exist")
//
//
//                }
//            case .failure(let error):
//                // A `City` value could not be initialized from the DocumentSnapshot.
//                print("-------------------Error decoding course: \(error)")
//            }
//        }
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
    
    func addElement(collection: String, documentId: String, field: String, toBeAdded: String ){
        let docRef = db.collection(collection).document(documentId)
        var prevData : [String] = []
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let fieldArray = data![field] as? Array ?? []
                print("fieldArray", fieldArray)
                for element in fieldArray{
                    prevData.append(element as! String)
                }
                print("prevDAta ", prevData)
                prevData.append(toBeAdded)
                // Set the "capital" field of the city 'DC'
                docRef.updateData([
                    field: prevData
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                //self.db.collection(collection).document(documentId).setData([ field: prevData], merge: true)
            } else {
                self.db.collection(collection).document(documentId).setData([ field: [toBeAdded]], merge: true)
            }
        }
    }
    
    func increaseField(collection: String, documentId: String, field: String, increaseAmount: Double){
        let docRef = db.collection(collection).document(documentId)
        var prevData : Double = 0.0
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let fieldValue = data![field] as? Double ?? 0.0
                prevData = fieldValue + increaseAmount
                self.db.collection(collection).document(documentId).setData([ field: prevData], merge: true)
            } else {
                self.db.collection(collection).document(documentId).setData([ field: increaseAmount], merge: true)
            }
        }
    }
    
    func addName(collection: String, documentId: String, name: String){
        self.db.collection(collection).document(documentId).setData([ "name": name])
    }
}
