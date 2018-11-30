//
//  ViewModel.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import Foundation

class ViewModel
{
    let firebaseUtil = FirebaseUtil.shared
    let healthUtil = HealthUtil.shared
    let slackUtil = SlackUtil.shared
    
    func configure()
    {
//        firebaseUtil.add(nickName: "momo", team_id: "momoyama")
//        firebaseUtil.addHealthData(nickName: "momo", stepCount: 500)
        
        firebaseUtil.read(nickName: "momo")
        firebaseUtil.readHealthData(nickName: "momo")
    }
}
