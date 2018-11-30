//
//  FirebaseUtil.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

open class FirebaseUtil {
    
    enum table: String
    {
        case users
        case healthData
    }

    enum keys: String
    {
        case nickname
        case team_id
        case stepCount
        case date
    }
    
    static public let shared = FirebaseUtil()
    private init(){}
    
    let db = Firestore.firestore()
    
    public struct Observables {
        
        let authSubject = PublishSubject<Bool>()
        var auth: Observable<Bool> { return authSubject }

        let stepCountSubject = PublishSubject<(Date, Int)>()
        var stepCount: Observable<(Date, Int)> { return stepCountSubject }
    }
    public let observables = Observables()
    
    
    func add(nickName: String, team_id: String)
    {
        var ref: DocumentReference? = nil
        ref = db.collection(table.users.rawValue).addDocument(data: [
            keys.nickname.rawValue: nickName,
            keys.team_id.rawValue: team_id
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func read(nickName: String)
    {
        db.collection(table.users.rawValue).whereField(keys.nickname.rawValue, isEqualTo: nickName).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func addHealthData(nickName: String, stepCount: Int)
    {
        var ref: DocumentReference? = nil
        ref = db.collection(table.healthData.rawValue).addDocument(data: [
            keys.nickname.rawValue: nickName,
            keys.stepCount.rawValue: stepCount,
            keys.date.rawValue: Timestamp(date: Date())
            //"date": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func readHealthData(nickName: String)
    {
        db.collection(table.healthData.rawValue).whereField(keys.nickname.rawValue, isEqualTo: nickName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}
