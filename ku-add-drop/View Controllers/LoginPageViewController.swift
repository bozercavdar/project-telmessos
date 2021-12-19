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

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginAction(_ sender: Any) {
        let username = usernameLabel.text!
        let password = passwordLabel.text!
        print(username, password)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password, completion: {result, error in
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
        
//        FirebaseAuth.Auth.auth().createUser(withEmail: username, password: password, completion: {result, error in
//            guard error == nil else {
//                return
//            }
//            print("created new")
//        })
        
        
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
