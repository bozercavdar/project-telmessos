//
//  UserPageViewController.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import grpc

class UserPageViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var courseTableView: UITableView!
    
    var userDataSource = UserDataSource()
    var courseDataSource = CourseDataSource()
    var numberOfRows = 0
    var courseRefArray : Array<DocumentReference> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfRows = userDataSource.getCourseNumber()
        courseRefArray = userDataSource.getCourseRefs()
        userDataSource.delegate = self
        userDataSource.refreshUser()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userDataSource.getUsername(completion: {username in
                self.usernameLabel.text = username})
    }
    
    @IBAction func imageSelect(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
//    func getCourseRefArray(completion: @escaping (Array<DocumentReference>?)->Void) {
//        userDataSource.getCourseRefs(completion: {courseRefArray in
//            completion(courseRefArray)})
//    }
        
    
    
//    func getRealIndex(indexPath: IndexPath, completion: @escaping (Int?)->Void) {
//        userDataSource.getCourseNumber(completion: {count in
//            if (count! == 0) {
//                completion(0)
//            }
//            let realIndex = indexPath.row.quotientAndRemainder(dividingBy: count!).remainder
//            completion(realIndex)
//        })
//    }
    
    func getRealIndex(indexPath: IndexPath) -> Int {
        if (numberOfRows == 0) {
            return 0;
        }
        let realIndex = indexPath.row.quotientAndRemainder(dividingBy: numberOfRows).remainder
        return realIndex
    }
    
    func refreshTable(){
        numberOfRows = userDataSource.getCourseNumber()
        courseRefArray = userDataSource.getCourseRefs()
        courseTableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
//        let storageRef = FIRStorage.storage().reference().child("myImage.png")
//        if let uploadData = UIImagePNGRepresentation(self.myImageView.image!) {
//            storageRef.put(uploadData, metadata: nil) { (metadata, error) in
//                if error != nil {
//                    print("error")
//                    completion(nil)
//                } else {
//                    completion((metadata?.downloadURL()?.absoluteString)!))
//                    // your uploaded photo url.
//                }
//           }
//     }
        
}

extension UserPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]){
        print(info)
        let image = info[.editedImage] as! UIImage
        self.userImageView.image = image
        self.dismiss(animated: true)
    }
}

extension UserPageViewController: UserDataSourceDelegate {
    func userLoaded() {
        numberOfRows = userDataSource.getCourseNumber()
        courseRefArray = userDataSource.getCourseRefs()
        courseTableView.reloadData()
        print("---------------- Reloaded")
    }
    
    func courseCountLoaded() {
    }
    
    func courseRefListLoaded() {
    }
    
    func userNameLoaded() {
    }
    
}

extension UserPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCourseCell", for: indexPath) as! ProfileCourseTableViewCell
        let index = getRealIndex(indexPath: indexPath)
        let array = courseRefArray
        self.courseDataSource.getCourseNameWithReference(docRef: array[index], completion: {name in
            cell.courseNameLabel.text = name})
        return cell
    }
    
    
}
