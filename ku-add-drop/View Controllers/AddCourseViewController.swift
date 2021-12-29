//
//  AddCourseViewController.swift
//  ku-add-drop
//
//  Created by Lab on 29.12.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class AddCourseViewController: UIViewController {

    @IBOutlet weak var courseNameLabel: UITextField!
    let user = FirebaseAuth.Auth.auth().currentUser
    var documentId = ""
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addCourse(_ sender: Any) {
        if let user = user{
            documentId = user.email!
            let courseName = courseNameLabel.text!
            var takenCourses : [String] = []
            let docRef = db.collection("users").document(documentId)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let courseArray = data!["courses"] as? Array ?? []
                    for course in courseArray{
                        takenCourses.append(course as! String)
                    }
                    takenCourses.append(courseName)
                    self.db.collection("users").document(self.documentId).setData([ "courses": takenCourses], merge: true)
                } else {
                    print("Document does not exist")
                }
            }
            courseNameLabel.text = ""

        }
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
