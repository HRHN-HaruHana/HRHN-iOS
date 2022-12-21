//
//  DeviceManager.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/21.
//
//  ref: https://github.com/hanulyun/Autolayout-iPhone

import DeviceKit

public enum DeviceGroup {
   case fourInches
   case fiveInches
   case notches
   case iPads
   public var rawValue: [Device] {
      switch self {
      case .fourInches:
         return [.iPhone5s, .iPhoneSE]
      case .fiveInches:
        return [.iPhone6, .iPhone6s, .iPhone7, .iPhone8, .simulator(.iPhone8)]
      case .notches:
         return Device.allDevicesWithSensorHousing
      case .iPads:
         return Device.allPads
      }
   }
}

class DeviceManager {
    static let shared: DeviceManager = DeviceManager()
    
    func isFourIncheDevices() -> Bool {
       return Device.current.isOneOf(DeviceGroup.fourInches.rawValue)
    }
    
    func isFiveIncheDevices() -> Bool {
        return Device.current.isOneOf(DeviceGroup.fiveInches.rawValue)
    }
    
    func isIPadDevices() -> Bool {
       return Device.current.isOneOf(DeviceGroup.iPads.rawValue)
    }
}
