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
        case totalDistance
        case totalEnergyBurned
    }
    
    static public let shared = FirebaseUtil()
    private init(){}
    
    let db = Firestore.firestore()

    public struct Observables {
        
        fileprivate let usersSubject = PublishSubject<[User]>()
        var users: Observable<[User]> { return usersSubject }
        
        fileprivate let userSubject = PublishSubject<User>()
        var user: Observable<User> { return userSubject }

        fileprivate let healthDataSubject = PublishSubject<[HealthData]>()
        var healthData: Observable<[HealthData]> { return healthDataSubject }
    }
    public let rx = Observables()
    
    
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
    
    func readUsers(team_id: String)
    {
        db.collection(table.users.rawValue).whereField(keys.team_id.rawValue, isEqualTo: team_id).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var users = [User]()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let user = User(document.data())
                    users.append(user)
                }
                self.rx.usersSubject.onNext(users)
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
                    
                    let user = User(document.data())
                    self.rx.userSubject.onNext(user)
                }
            }
        }
    }

    func addHealthData(nickName: String, stepCount: Int, totalDistance: String, totalEnergyBurned: String)
    {
        var ref: DocumentReference? = nil
        ref = db.collection(table.healthData.rawValue).addDocument(data: [
            keys.nickname.rawValue: nickName,
            keys.stepCount.rawValue: stepCount,
            keys.totalEnergyBurned.rawValue: totalEnergyBurned,
            keys.totalDistance.rawValue: totalDistance,
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
    
    func readHealthData()
    {
        db.collection(table.healthData.rawValue).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var healthData = [HealthData]()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    healthData.append(HealthData(document.data()))
                }
                self.rx.healthDataSubject.onNext(healthData)
            }
        }
    }
}

struct User : Codable
{
    var nickname : String
    var team_id : String
    
    init(_ dic: Dictionary<String, Any>) {
        self.nickname = dic[FirebaseUtil.keys.nickname.rawValue] as! String
        self.team_id = dic[FirebaseUtil.keys.team_id.rawValue] as! String
    }
}

struct HealthData : Codable
{
    var nickname : String
    var stepCount : Int?
    var totalEnergyBurned: String?
    var totalDistance: String?
    var date: String?
    
    init(_ dic: Dictionary<String, Any>) {
        self.nickname = dic[FirebaseUtil.keys.nickname.rawValue] as! String
        self.stepCount = dic[FirebaseUtil.keys.stepCount.rawValue] as? Int
        self.totalEnergyBurned = dic[FirebaseUtil.keys.totalEnergyBurned.rawValue] as? String
        self.totalDistance = dic[FirebaseUtil.keys.totalDistance.rawValue] as? String
    }
}
