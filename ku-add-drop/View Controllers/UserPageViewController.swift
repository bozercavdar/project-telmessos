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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = self.user{
            usernameLabel.text = user.email!
            getUsername(collection: "users", documentId: user.email!)
        }
        
        // Do any additional setup after loading the view.
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
    func getUsername(collection: String, documentId: String) -> String? {

        var fullName = ""
        let docRef = db.collection(collection).document(documentId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let name = data!["name"] as! String
                let surname = data!["surname"] as! String
                fullName = name + " " + surname
                print(fullName)
                
            } else {
                print("------------------ Error")
            }
        }
        return fullName
    }
    
    

}

extension UserPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]){
        let image = info[.editedImage] as! UIImage
        self.userImageView.image = image
        self.dismiss(animated: true)
    }
}
