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
    var userDataSource = UserDataSource()
    
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

        courseDataSource.updateCourse(documentId: courseName, courseName: courseName, instructorName: instructorName, commentContent: commentContent, courseRating: Int(courseRating), instructorRating: Int(instructorRating), completion: {msg in
            print(msg)
            self.userDataSource.refreshUser()
        })
        
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
  
}
