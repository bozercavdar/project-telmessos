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

    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var curtainView: UIView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curtainView.isHidden = false
        self.title = "Login"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ifLoggedIn = userDefault.bool(forKey: "loggedIn")
        let savedUsername = userDefault.string(forKey: "username")
        let savedPassword = userDefault.string(forKey: "password")
        if ifLoggedIn {
            FirebaseAuth.Auth.auth().signIn(withEmail: savedUsername!, password: savedPassword!, completion: {result, error in
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
        }else{
            curtainView.isHidden = true
        }
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
        
        FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password, completion: {result, error in
            guard error == nil else {
                print("wrong credentials")
                return
            }
            self.userDefault.set(true, forKey: "loggedIn")
            self.userDefault.set(username, forKey: "username")
            self.userDefault.set(password, forKey: "password")
            
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
