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
    private let firebaseUtil = FirebaseUtil.shared
    private let healthUtil = HealthUtil.shared
    private let slackUtil = SlackUtil.shared
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    func configure()
    {
        healthUtil.observables.workouts.subscribe(onNext: {[weak self] (workouts) in
            guard let _self = self else { return }
            
            if let workout = workouts.last
            {
                let totalDistance = workout.totalDistance?.description ?? ""
                let totalEnergyBurned = workout.totalEnergyBurned?.description ?? ""
                
                _self.firebaseUtil.addHealthData(nickName: "terada", stepCount: 600, totalDistance: totalDistance, totalEnergyBurned: totalEnergyBurned)
            }
        }).disposed(by: disposeBag)
        
        healthUtil.getWorkouts()
    }
}
