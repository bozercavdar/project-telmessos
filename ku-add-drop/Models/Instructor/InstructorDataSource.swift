//
//  InstructorDataSource.swift
//  ku-add-drop
//
//  Created by Lab on 6.01.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class InstructorDataSource {
    var delegate : InstructorDataSourceDelegate?
    let db = Firestore.firestore()
    
    init() {
        
    }
    
    func updatedAddInstructor(documentId: String, name: String, inputScore: Int){
        var instructorObject = Instructor(instructorName: name, totalScore: 0, totalRateAmount: 0)
        let docRef = db.collection("instructors").document(documentId)
        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Instructor.self)
            }
            switch result {
            case .success(let instructor):
                if let instructor = instructor {
                    
                    instructorObject.totalScore = instructor.totalScore
                    instructorObject.totalRateAmount = instructor.totalRateAmount
                    print("---------------------Instructor: \(instructorObject)")
                    
                    instructorObject.totalScore += inputScore
                    instructorObject.totalRateAmount += 1
                    
                    do {
                        try self.db.collection("instructors").document(documentId).setData(from: instructorObject)
                    } catch let error {
                        print("Error writing instructor to Firestore: \(error)")
                    }
                } else {
                    print("--------------------Document does not exist")
                    
                    instructorObject.totalScore += inputScore
                    instructorObject.totalRateAmount += 1
                    do {
                        try self.db.collection("instructors").document(documentId).setData(from: instructorObject)
                    } catch let error {
                        print("Error writing instructor to Firestore: \(error)")
                    }
                }
            case .failure(let error):

                print("-------------------Error decoding instructor: \(error)")
            }
        }
    }
    
    func getInstructorWithReference(docRef: DocumentReference ,completion: @escaping (String?)->Void) {
        docRef.getDocument(completion: { (document, error) in
            let result = Result {
              try document?.data(as: Instructor.self)
            }
            switch result {
            case .success(let instructor):
                if let instructor = instructor {
                    completion(instructor.instructorName)
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
