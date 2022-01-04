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
    
    var courseName : String = ""
    let user = FirebaseAuth.Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = user?.email
        // Do any additional setup after loading the view.
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
