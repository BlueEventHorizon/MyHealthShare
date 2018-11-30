//
//  HealthUtil.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import HealthKit

open class HealthUtil {
    
    private let healthStore = HKHealthStore()
    static public let shared = HealthUtil()
    private init(){}


}
