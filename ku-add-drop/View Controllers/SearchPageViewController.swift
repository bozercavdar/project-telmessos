//
//  SearchPageViewController.swift
//  ku-add-drop
//
//  Created by Lab on 4.01.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class SearchPageViewController: UIViewController {

    @IBOutlet weak var courseNameField: UITextField!
    var courseName : String = ""
    let user = FirebaseAuth.Auth.auth().currentUser
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchClass(_ sender: Any) {
        courseName = courseNameField.text!
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let courseSearchViewController = segue.destination as! CourseDetailViewController
        courseSearchViewController.searchedCourse = courseNameField.text!
    }
}
