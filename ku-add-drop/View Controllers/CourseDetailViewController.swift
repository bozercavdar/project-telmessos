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
    var numberOfInstructorRows = 0
    var numberOfCommentRows = 0
    var commentRefArray : Array<DocumentReference> = []
    var instructorRefArray : Array<DocumentReference> = []
    var searchedCourse : String?
    var tableViewSection : Int = 0
    
    @IBOutlet weak var commentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        commentTableView.estimatedRowHeight = 200
//        commentTableView.rowHeight = UITableView.automaticDimension
        courseDataSource.delegate = self
        courseDataSource.reloadCourse(documentRef: searchedCourse!)
        
        numberOfCommentRows = courseDataSource.getCommentNumber()
        commentRefArray = courseDataSource.getCommentRefs()
        
        numberOfInstructorRows = courseDataSource.getInstructorNumber()
        instructorRefArray = courseDataSource.getInstructorRefs()

        courseNameLabel.text = searchedCourse!
        // Do any additional setup after loading the view.
    }
    
    
    func getInstructorRealIndex(indexPath: IndexPath) -> Int {
        if (numberOfInstructorRows == 0) {
            return 0;
        }
        let realIndex = indexPath.row.quotientAndRemainder(dividingBy: numberOfInstructorRows + numberOfCommentRows).remainder
        return realIndex
    }
    
    func getCommentRealIndex(indexPath: IndexPath) -> Int {
        if (numberOfCommentRows == 0) {
            return 0;
        }
        let realIndex = indexPath.row.quotientAndRemainder(dividingBy: numberOfCommentRows + numberOfInstructorRows).remainder
        return realIndex
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
extension CourseDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // return number of instructors
            return courseDataSource.getInstructorNumber()
        }
        return courseDataSource.getCommentNumber()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // return ninstructor cell
            let instructorCell = tableView.dequeueReusableCell(withIdentifier: "CourseInstructorCell", for: indexPath) as! CourseInstructorTableViewCell
            let index = getInstructorRealIndex(indexPath: indexPath)
            let array = instructorRefArray
            self.instructorDataSource.getInstructorWithReference(docRef: array[index], completion: {name in
                instructorCell.instructorNameLabel.text = name})
            return instructorCell
        }
        // return comment cell
        let commentCell = tableView.dequeueReusableCell(withIdentifier: "CourseCommentCell", for: indexPath) as! CommentTableViewCell
        let index = getCommentRealIndex(indexPath: indexPath)
        let array = commentRefArray
        self.commentDataSource.getCommentWithReference(docRef: array[index], completion: {content in
            commentCell.commentContentLabel.text = content!})
        return commentCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Instructors"
        }else {
            return "Comments"
        }
    }
}

extension CourseDetailViewController: CourseDataSourceDelegate{
    func commentRefListLoaded() {
        
    }
    
    func commentCountLoaded() {
        
    }
    
    func courseLoaded() {
        numberOfCommentRows = courseDataSource.getCommentNumber()
        commentRefArray = courseDataSource.getCommentRefs()
        
        numberOfInstructorRows = courseDataSource.getInstructorNumber()
        instructorRefArray = courseDataSource.getInstructorRefs()

        commentTableView.reloadData()
    }
    
    func instructorCountLoaded() {
        
    }
    
    
}
