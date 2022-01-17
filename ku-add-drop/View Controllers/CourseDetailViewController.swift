//
//  CourseDetailViewController.swift
//  ku-add-drop
//
//  Created by Lab on 20.12.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import grpc

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var courseNameLabel: UILabel!
    
    
    var commentDataSource = CommentDataSource()
    var courseDataSource = CourseDataSource()
    var instructorDataSource = InstructorDataSource()
    var numberOfRows = 0
    var commentRefArray : Array<DocumentReference> = []
    var instructorRefArray : Array<DocumentReference> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfRows = courseDataSource.getCommentNumber()
        commentRefArray = courseDataSource.getCommentRefs()
   //     commentDataSource.delegate = self
        //courseNameLabel.text = searchedCourseName!
        // Do any additional setup after loading the view.
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
//
//extension CourseDetailViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            // return number of instructors
//        }
//        // return number of comments
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if section == 0 {
//            // return ninstructor cell
//            let instructorCell = tableView.dequeueReusableCell(withIdentifier: "InstructorCell") as!
//
//            return instructorCell
//        }
//        // return comment cell
//        return 0
//    }
//}
//
//extension CourseDetailViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
//}
