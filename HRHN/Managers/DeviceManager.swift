//
//  DeviceManager.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/21.
//
//  ref: https://github.com/hanulyun/Autolayout-iPhone

import DeviceKit

private enum DeviceGroup {
    case homeButtonDevice
    var rawValue: [Device] {
        switch self {
        case .homeButtonDevice:
            return [.iPhone8, .iPhone8Plus, .iPhoneSE2, .iPhoneSE3]
        }
    }
}

class DeviceManager {
    static let shared: DeviceManager = DeviceManager()
    
    func isHomeButtonDevice() -> Bool {
        return Device.current.isOneOf(DeviceGroup.homeButtonDevice.rawValue)
    }
}
