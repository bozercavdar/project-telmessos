//
//  LoginPageViewController.swift
//  ku-add-drop
//
//  Created by Lab on 19.12.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginPageViewController: UIViewController {

//    let userDefault = UserDefaults.standard
//    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let ifLoggedIn = userDefault.bool(forKey: "loggedIn")
//        let savedUsername = userDefault.string(forKey: "username")
//        let savedPassword = userDefault.string(forKey: "password")
//        if ifLoggedIn {
//            let credential = EmailAuthProvider.credential(withEmail: savedUsername!, password: savedPassword!)
//            Auth.auth().signInAndRetrieveData(with: credential, completion: {result, error in
//                if error == nil {
//                    self.userDefault.set(true, forKey: "loggedin")
//                    self.userDefault.synchronize()
//                    print(result?.user.email)
//                }
//            })
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
//
//            // This is to get the SceneDelegate object from your view controller
//            // then call the change root view controller function to change to main tab bar
//            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
//        }
//    }
    
    @IBAction func shortcut(_ sender: Any) {
        FirebaseAuth.Auth.auth().signIn(withEmail: "fbulgur17@ku.edu.tr", password: "123456", completion: {result, error in
            guard error == nil else {
                print("wrong credentials")
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")

            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        })
    }
    
    @IBAction func passwordViewAction(_ sender: Any) {
        if(iconClick == true){
            passwordLabel.isSecureTextEntry = false
        }else{
            passwordLabel.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let username = usernameLabel.text!
        let password = passwordLabel.text!
//        credential = EmailAuthProvider.credential(withEmail: username, password: password)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password, completion: {result, error in
            guard error == nil else {
                print("wrong credentials")
                return
            }
//            self.userDefault.set(true, forKey: "loggedIn")
//            self.userDefault.set(username, forKey: "username")
//            self.userDefault.set(password, forKey: "password")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")

            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
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
