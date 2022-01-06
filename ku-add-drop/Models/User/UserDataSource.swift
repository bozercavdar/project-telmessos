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
    var documentId = ""
    
    init() {
        if let user = self.user{
            documentId = user.email!
        }
    }
    
    func getUsername(completion: @escaping (String?)->Void) {
        
        var fullName = ""
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
    
    func addCourse(courseName: String){
        var userObject = User(name: "", surname: "", email: "", imageName: "", takenCoursesList: [])
        let userDocRef = db.collection("users").document(documentId)
        userDocRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    //retrieve previos information about the course
                    userObject.name = user.name
                    userObject.surname = user.surname
                    userObject.email = user.email
                    userObject.imageName = user.imageName
                    userObject.takenCoursesList = user.takenCoursesList
                    print("---------------------User: \(userObject)")
                    
                    //update takencourse list
                    let courseRef = self.db.collection("courses").document(courseName)
                    var ifExists = false
                    for ref in userObject.takenCoursesList{
                        if ref.path == courseRef.path{
                            ifExists = true
                        }
                    }
                    if(!ifExists){
                        userObject.takenCoursesList.append(courseRef)
                    }
                    
                    //update user in firebase
                    do {
                        try self.db.collection("users").document(userObject.email).setData(from: userObject)
                    } catch let error {
                        print("Error writing comment to Firestore: \(error)")
                    }
                    
                } else {
                    //impossible case
                    print("-------------------Error")
                }
            case .failure(let error):
                // A `User` value could not be initialized from the DocumentSnapshot.
                print("-------------------Error decoding user: \(error)")
            }
        }
    }
}
