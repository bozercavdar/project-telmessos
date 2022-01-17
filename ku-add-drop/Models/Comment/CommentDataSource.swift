//
//  CommentDataSource.swift
//  ku-add-drop
//
//  Created by Lab on 6.01.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class CommentDataSource {
    
    let db = Firestore.firestore()
    
    init() {
    }
    
    func updatedAddComment(owner: String, courseName: String, content: String, courseScore: Int){
        var commentObject = Comment(courseName: "", owner: "", content: "", courseScore: 0)
        let documentId = owner + "-" + courseName
        let docRef = db.collection("comments").document(documentId)
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Comment.self)
            }
            switch result {
            case .success(let comment):
                if let comment = comment {
                    
                    commentObject.courseName = comment.courseName
                    commentObject.owner = comment.owner
                    commentObject.content = comment.content
                    commentObject.courseScore = comment.courseScore
                    print("---------------------Instructor: \(commentObject)")
                    
                    commentObject.content = content
                    commentObject.courseScore = courseScore
                    
                    do {
                        try self.db.collection("comments").document(documentId).setData(from: commentObject)
                    } catch let error {
                        print("Error writing comment to Firestore: \(error)")
                    }
                } else {
                    print("--------------------Document does not exist")
                    
                    commentObject.owner = owner
                    commentObject.courseName = courseName
                    commentObject.content = content
                    commentObject.courseScore = courseScore
                    
                    do {
                        try self.db.collection("comments").document(documentId).setData(from: commentObject)
                    } catch let error {
                        print("Error writing comment to Firestore: \(error)")
                    }
                }
            case .failure(let error):

                print("-------------------Error decoding instructor: \(error)")
            }
        }
    }
    
    
    func getCommentWithReference(docRef: DocumentReference ,completion: @escaping (String?)->Void) {
        docRef.getDocument(completion: { (document, error) in
            let result = Result {
              try document?.data(as: Comment.self)
            }
            switch result {
            case .success(let comment):
                if let comment = comment {
                    completion(comment.content)
                } else {
                    //impossible case
                    print("-------------------Error")
                }
            case .failure(let error):
                // A `User` value could not be initialized from the DocumentSnapshot.
                print("-------------------Error decoding user: \(error)")
            }
        })
    }
    

    
}
