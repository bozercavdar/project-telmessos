//
//  UserDataSource.swift
//  ku-add-drop
//
//  Created by Lab on 6.01.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class UserDataSource {
    let db = Firestore.firestore()
    var delegate: UserDataSourceDelegate?
    let user = FirebaseAuth.Auth.auth().currentUser
    init() {
        
    }
    
    func getUsername(completion: @escaping (String?)->Void) {
        
        var documentId = ""
        var fullName = ""
        if let user = self.user{
            documentId = user.email!
        }
        let docRef = db.collection("users").document(documentId)
        docRef.getDocument (completion: { document, error  in
            if let document = document, document.exists {
                let data = document.data()
                let name = data!["name"] as! String
                let surname = data!["surname"] as! String
                fullName = name + " " + surname
                completion(fullName)
            } else {
                print("------------------ Error in getting name of the user")
                completion(fullName)
            }
        })
        
        DispatchQueue.main.async {
            self.delegate?.userNameLoaded()
        }
    }
    
    func addUser(userObject: User) {
        do {
            try self.db.collection("users").document(userObject.email).setData(from: userObject)
        } catch let error {
            print("Error writing comment to Firestore: \(error)")
        }
    }
    
}
