//
//  HealthUtil.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import Foundation
import HealthKit
import RxSwift

// https://nnsnodnb.hatenablog.jp/entry/use-health-sample
// https://qiita.com/nkhrk/items/e0f39b8c4794b71d858d
// https://stackoverflow.com/questions/36559581/healthkit-swift-getting-todays-steps

open class HealthUtil {
    
    private let healthStore = HKHealthStore()
    static public let shared = HealthUtil()
    private init(){}
    
    public struct Observables {
        
        fileprivate let authSubject = PublishSubject<Bool>()
        var auth: Observable<Bool> { return authSubject }
        
        fileprivate let workoutsSubject = PublishSubject<[HKWorkout]>()
        var workouts: Observable<[HKWorkout]> { return workoutsSubject }
        
        fileprivate let stepCountSubject = PublishSubject<(Date, Int)>()
        var stepCount: Observable<(Date, Int)> { return stepCountSubject }
    }
    public let observables = Observables()
    
    public func auth() {
        
        let readDataTypes: Set<HKObjectType> = [
            HKWorkoutType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            ]
        
        healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { (success, error) in
            self.observables.authSubject.onNext(success)
        }
    }
    
    public func getWorkouts() {
        
        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error) in
            if let _results = results as? [HKWorkout]
            {
                self.observables.workoutsSubject.onNext(_results)
            }
        }
        self.healthStore.execute(sampleQuery)
    }
    
    public func getHeartRates(workout: HKWorkout) {
        guard let type = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.discreteAverage, .discreteMin, .discreteMax]) { (query, statistic, error) in
            guard let _statistic = statistic, error == nil else {
                return
            }
            print("最低値 \(_statistic.minimumQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0) bpm")
            print("最高値 \(_statistic.maximumQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0) bpm")
            print("平均値 \(_statistic.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0) bpm")
        }
        healthStore.execute(query)
    }
    
    public func stepCount(on date: Date = Date()) {
        
        let startDay = Date(year: date.year, month: date.month, day: date.day-3, hour: 0, minute: 0, second: 0)
        let timeIntervalSince1970 = startDay.timeIntervalSince1970
        let nextDay = timeIntervalSince1970 + (3600 * 24)
        let endDay = Date(timeIntervalSince1970: nextDay)
        
        // HKSampleから歩数の取得をリクエスト
        let type = HKSampleType.quantityType(forIdentifier: .stepCount)
        //let type = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)
        
        // 対象日の24時間分の歩数を取得する
        let predicate = HKQuery.predicateForSamples(withStart: startDay, end: endDay, options: .strictStartDate)
        // 指定期間内のデータを取得する
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var stepCount: Int = 0
            
            // 指定期間で取得できた歩数の合計を計算
            if let _results = results as? [HKQuantitySample], _results.count > 0
            {
                for result in _results
                {
                    stepCount += Int(result.quantity.doubleValue(for: HKUnit.count()))
                }
            }
            // 合計歩数をコールバック関数へ返す
            self.observables.stepCountSubject.onNext((date, stepCount))
        }
        
        healthStore.execute(query)
    }
}

