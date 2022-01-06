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
            getUsername(collection: "users", documentId: user.email!, completion: {username in
                self.usernameLabel.text = username})
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
    func getUsername(collection: String, documentId: String, completion: @escaping (String?)->Void) {

        var fullName = ""
        let docRef = db.collection(collection).document(documentId)
        docRef.getDocument (completion: { document, error  in
            if let document = document, document.exists {
                let data = document.data()
                let name = data!["name"] as! String
                let surname = data!["surname"] as! String
                fullName = name + " " + surname

                completion(fullName)
                //return "fullName"
            } else {
                print("------------------ Error")
            }
        })

    }
    
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
        
//        func addElement(collection: String, documentId: String, field: String, toBeAdded: String ){
//            let docRef = db.collection(collection).document(documentId)
//            var prevData : [String] = []
//            docRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    let data = document.data()
//                    let fieldArray = data![field] as? Array ?? []
//                    for element in fieldArray{
//                        prevData.append(element as! String)
//                    }
//                    prevData.append(toBeAdded)
//                    self.db.collection(collection).document(documentId).setData([ field: prevData], merge: true)
//                } else {
//                    self.db.collection(collection).document(documentId).setData([ field: [toBeAdded]], merge: true)
//                }
//            }
//        }

}

extension UserPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]){
        print(info)
        let image = info[.editedImage] as! UIImage
        self.userImageView.image = image
        self.dismiss(animated: true)
    }
}
