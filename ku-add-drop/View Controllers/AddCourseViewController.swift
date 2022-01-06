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
    var courseName : String = ""
    let user = FirebaseAuth.Auth.auth().currentUser
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addCourse(_ sender: Any) {
        if let user = user{
            let documentId = user.email!
            courseName = courseNameLabel.text!
            addElement(collection: "users", documentId: documentId, field: "courses", toBeAdded: courseName)
            
            courseNameLabel.text = ""
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let courseDetailViewController = segue.destination as! AddCourseDetailPageViewController
        courseDetailViewController.addedCourseName = courseName
    }
    
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
    

}
