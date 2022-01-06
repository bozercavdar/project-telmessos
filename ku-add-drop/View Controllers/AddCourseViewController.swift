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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addCourse(_ sender: Any) {
        courseName = courseNameLabel.text!
        courseNameLabel.text = ""
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let courseDetailViewController = segue.destination as! AddCourseDetailPageViewController
        courseDetailViewController.addedCourseName = courseName
    }
        

}
