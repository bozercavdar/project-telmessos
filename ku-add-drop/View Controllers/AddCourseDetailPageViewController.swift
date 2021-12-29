//
//  AddCourseDetailPageViewController.swift
//  ku-add-drop
//
//  Created by Lab on 29.12.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddCourseDetailPageViewController: UIViewController {

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseRatingSlider: UISlider!
    @IBOutlet weak var instructorTextInput: UITextField!
    @IBOutlet weak var instructorRatingSlider: UISlider!
    @IBOutlet weak var commentTextView: UITextView!
    
    let db = Firestore.firestore()
    var addedCourseName: String?
    
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
        //for courses
        addName(collection: "courses", documentId: courseName, name: courseName)
        addElement(collection: "courses", documentId: courseName, field: "instructors", toBeAdded: instructorName)
        addElement(collection: "courses", documentId: courseName, field: "comments", toBeAdded: commentContent)
        increaseField(collection: "courses", documentId: courseName, field: "totalRating", increaseAmount: Double(courseRating))
        increaseField(collection: "courses", documentId: courseName, field: "voterAmount", increaseAmount: 1)
        
        //for instructors
        addName(collection: "instructors", documentId: instructorName, name: instructorName)
        increaseField(collection: "instructors", documentId: instructorName, field: "totalRating", increaseAmount: Double(instructorRating))
        increaseField(collection: "instructors", documentId: instructorName, field: "voterAmount", increaseAmount: 1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addElement(collection: String, documentId: String, field: String, toBeAdded: String ){
        let docRef = db.collection(collection).document(documentId)
        var prevData : [String] = []
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let fieldArray = data![field] as? Array ?? []
                for element in fieldArray{
                    prevData.append(element as! String)
                }
                prevData.append(toBeAdded)
                self.db.collection(collection).document(documentId).setData([ field: prevData], merge: true)
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
