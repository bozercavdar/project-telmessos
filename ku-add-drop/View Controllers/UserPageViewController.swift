//
//  UserPageViewController.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import grpc

class UserPageViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var courseTableView: UITableView!
    
    let userDefault = UserDefaults.standard
    
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
    
    @IBAction func logoutButton(_ sender: Any) {
        do
        {
            try Auth.auth().signOut()
            self.userDefault.set(false, forKey: "loggedIn")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginPageViewController = storyboard.instantiateViewController(withIdentifier: "LoginPage") as! LoginPageViewController
            self.navigationController?.pushViewController(loginPageViewController, animated: true)
            
            let loginNavigationController = storyboard.instantiateViewController(identifier: "LoginNavigationController")

            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavigationController)
            
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
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
