//
//  ViewModel.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel
{
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let firebaseUtil = FirebaseUtil.shared
    private let healthUtil = HealthUtil.shared
    private let slackUtil = SlackUtil.shared
    
    func configure()
    {
        healthUtil.observables.workouts.subscribe(onNext: {[weak self] (workouts) in
            guard let _self = self else { return }
            
            for workout in workouts {
                print(workout.startDate)
                print(workout.endDate)
                print(String(format: "Distance   : %@", workout.totalDistance ?? "no data"))
                print(String(format: "EnergyBurn : %@", workout.totalEnergyBurned ?? "no data"))
            }

        }).disposed(by: disposeBag)
        healthUtil.getWorkouts()
        
        healthUtil.observables.stepCount.subscribe(onNext: {[weak self] (stepCount) in
            guard let _self = self else { return }
            
            
            
        }).disposed(by: disposeBag)
        healthUtil.stepCount()
        
//        firebaseUtil.add(nickName: "momo", team_id: "momoyama")
//        firebaseUtil.addHealthData(nickName: "momo", stepCount: 500)
        
        //firebaseUtil.observables.
        
        
        firebaseUtil.read(nickName: "momo")
        firebaseUtil.readHealthData(nickName: "momo")
    }
}
