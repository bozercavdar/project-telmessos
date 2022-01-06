//
//  SignUpPageViewController.swift
//  ku-add-drop
//
//  Created by Lab on 20.12.2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpPageViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var surnameLabel: UITextField!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    var iconClick = true
    let db = Firestore.firestore()
    let userDataSource = UserDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func passwordViewAction(_ sender: Any) {
        if(iconClick == true){
            passwordLabel.isSecureTextEntry = false
        }else{
            passwordLabel.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBAction func signupAction(_ sender: Any) {
        let name = nameLabel.text!
        let surname = surnameLabel.text!
        let username = usernameLabel.text!
        let password = passwordLabel.text!
        print(username, password)
        FirebaseAuth.Auth.auth().createUser(withEmail: username, password: password, completion: {result, error in
            guard error == nil else {
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")

            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
            // Add a new document
            let userObject = User(name: name, surname: surname, email: username, imageName: "", takenCoursesList: [])
            self.userDataSource.addUser(userObject: userObject)
        })
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
