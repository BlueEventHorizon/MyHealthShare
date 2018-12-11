//
//  CoreMotionUtil.swift
//  MyHealthShare
//
//  Created by Katsuhiko Terada on 2018/12/12.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import CoreMotion

class CoreMotionUtil
{
    private let motionManager = CMMotionManager()
    private let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let altimeter = CMAltimeter()
    
    static public let shared = CoreMotionUtil()
    private init(){}
    
    func stop()
    {
        // バックグラウンドで動作させる場合は適切な場所でstopする
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopGyroUpdates()
        self.activityManager.stopActivityUpdates()
        self.pedometer.stopUpdates()
        self.pedometer.stopEventUpdates()
        self.altimeter.stopRelativeAltitudeUpdates()
    }
    
    /**
     加速度取得
     */
    func getAcceleration(interval: TimeInterval, completion: @escaping (CMAcceleration) -> Void, error errorHandler: @escaping (Error?) -> Void ) {
        
        guard self.motionManager.isAccelerometerAvailable else {
            errorHandler(nil)
            return
        }
        
        self.motionManager.accelerometerUpdateInterval = interval
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { (data: CMAccelerometerData?, error: Error?) in
            DispatchQueue.main.async {
                guard let _data = data, error == nil else {
                    errorHandler(error)
                    return
                }
                completion (_data.acceleration)
                
                //                print("Acc X: \(_data.acceleration.x.description)")
                //                print("Acc Y: \(_data.acceleration.y.description)")
                //                print("Acc Z: \(_data.acceleration.z.description)")
            }
        })
    }
    
    /**
     ジャイロデータ取得
     */
    func getRotationRate(interval: TimeInterval, completion: @escaping (CMRotationRate) -> Void, error errorHandler: @escaping (Error?) -> Void ) {
        
        guard self.motionManager.isGyroAvailable else {
            errorHandler(nil)
            return
        }
        
        self.motionManager.gyroUpdateInterval = interval
        self.motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: { (data: CMGyroData?, error: Error?) in
            DispatchQueue.main.async {
                guard let _data = data, error == nil else {
                    errorHandler(error)
                    return
                }
                completion (_data.rotationRate)
                
                //                print("Gyro X: \(_data.rotationRate.x.description)")
                //                print("Gyro Y: \(_data.rotationRate.y.description)")
                //                print("Gyro Z: \(_data.rotationRate.z.description)")
            }
        })
    }
    
    /**
     ユーザの状態検出
     */
    func getMotionActivity(completion: @escaping (CMMotionActivity) -> Void, error errorHandler: @escaping () -> Void ) {
        
        guard CMMotionActivityManager.isActivityAvailable() else {
            errorHandler()
            return
        }
        
        self.activityManager.startActivityUpdates(to: OperationQueue.current!, withHandler: { (data: CMMotionActivity?) in
            DispatchQueue.main.async {
                guard let _data = data else {
                    errorHandler()
                    return
                }
                completion (_data)
                
                var confidenceLabel: String = ""
                switch _data.confidence {
                case .low:
                    confidenceLabel = "Low"
                case .medium:
                    confidenceLabel = "Medium"
                case .high:
                    confidenceLabel = "High"
                }
                
                print("confidence: \(confidenceLabel)")
                print("stationary: \(_data.stationary ? "YES" : "NO")")
                print("walking: \(_data.walking ? "YES" : "NO")")
                
                print("running: \(_data.running ? "YES" : "NO")")
                print("automotive: \(_data.automotive ? "YES" : "NO")")
                print("cycling: \(_data.cycling ? "YES" : "NO")")
            }
        })
    }
    
    /**
     Pedometer
     */
    func getPedometer(from date: Date, completion: @escaping (CMPedometerData) -> Void, error errorHandler: ((Error?) -> Void )? = nil) {
        
        self.pedometer.startUpdates(from: date, withHandler: { (data: CMPedometerData?, error: Error?) in
            DispatchQueue.main.async {
                guard let _data = data else {
                    errorHandler?(error)
                    return
                }
                completion (_data)
                
                print("歩数: \(_data.numberOfSteps.intValue)")
                print("距離: \(_data.distance ?? 0) [m]")
                print("上り階数: \(_data.floorsAscended ?? 0) [floors]")
                print("下り階数: \(_data.floorsDescended ?? 0) [floors]")
                print("平均の活動ペース: \(_data.averageActivePace ?? 0) [sec/meter]")
                print("現在の活動ペース: \(_data.currentPace ?? 0) [sec/meter]")
                print("現在のケーデンス: \(_data.currentCadence ?? 0) [steps/sec]")
            }
        })
    }
    
    /**
     Pedometer
     */
    func getPedometer(from fromDate: Date, to toDate: Date, completion: @escaping (CMPedometerData) -> Void, error errorHandler: ((Error?) -> Void)? = nil ) {
        
        self.pedometer.queryPedometerData(from: fromDate, to: toDate, withHandler: { (data: CMPedometerData?, error: Error?) in
            DispatchQueue.main.async {
                guard let _data = data, error == nil else {
                    errorHandler?(error)
                    return
                }
                completion (_data)
                
                print("歩数: \(_data.numberOfSteps.intValue)")
                print("距離: \(_data.distance ?? 0) [m]")
                print("上り階数: \(_data.floorsAscended ?? 0) [floors]")
                print("下り階数: \(_data.floorsDescended ?? 0) [floors]")
                print("平均の活動ペース: \(_data.averageActivePace ?? 0) [sec/meter]")
                print("現在の活動ペース: \(_data.currentPace ?? 0) [sec/meter]")
                print("現在のケーデンス: \(_data.currentCadence ?? 0) [steps/sec]")
            }
        })
    }
    
    /**
     歩行のイベントタイプを取得
     .pause: 一時停止，.resume: 再開
     */
    func getPedometerEvent(completion: @escaping (CMPedometerEvent) -> Void, error errorHandler: @escaping (Error?) -> Void ) {
        
        guard CMPedometer.isPedometerEventTrackingAvailable() else {
            errorHandler(nil)
            return
        }
        
        self.pedometer.startEventUpdates(handler: { (event: CMPedometerEvent?, error: Error?) in
            DispatchQueue.main.async {
                guard let _event = event, error == nil else {
                    errorHandler(error)
                    return
                }
                completion (_event)
            }
        })
    }
    
    /**
     相対高度・気圧
     起動したところからXX[m]
     気圧は取得データは[kPa]なので10倍して[hPa]に
     */
    func getAltitudeData(completion: @escaping (CMAltitudeData) -> Void, error errorHandler: @escaping (Error?) -> Void ) {
        
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            errorHandler(nil)
            return
        }
        
        self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (data: CMAltitudeData?, error: Error?) in
            DispatchQueue.main.async {
                guard let _data = data, error == nil else {
                    errorHandler(error)
                    return
                }
                completion (_data)
                
                //                self.relativeAttitudeLabel.text = NSString(format: "%.2f[m]", Double(_data.relativeAltitude)) as String
                //                self.pressureLabel.text = NSString(format: "%.2f[hPa]", Double(_data.pressure)*10) as String
            }
        })
    }
}
