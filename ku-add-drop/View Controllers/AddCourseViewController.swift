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
            
            db.collection("users").document(documentId)
                .addSnapshotListener { documentSnapshot, error in
                  guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                  }
                  guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                  }
                    let userName = data["name"] as? String ?? ""
                    print(userName)
                }
            
            db.collection("users").document(documentId).setData([ "courses": [courseName]], merge: true)

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
