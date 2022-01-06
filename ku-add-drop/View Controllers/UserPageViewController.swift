//
//  UserPageViewController.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class UserPageViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var courseName : String = ""
    let user = FirebaseAuth.Auth.auth().currentUser
    let db = Firestore.firestore()
    var userDataSource = UserDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataSource.delegate = self
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
    func userNameLoaded() {
    }
    
}
