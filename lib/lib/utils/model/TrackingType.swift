//
//  TrackingType.swift
//  SerescoMapsUtils
//
//  Created by Diego Salcedo on 18/08/22.
//  Copyright © 2022 Seresco. All rights reserved.
//

import Foundation

public enum TrackingType {
    case manual, automatic
}

public enum AutomaticTrackingType {
    case fiveSeconds, tenSeconds, thirtySeconds, sixtySeconds
    
    public var time: Double {
        switch self {
        case .fiveSeconds:
            return 5.0
        case .tenSeconds:
            return 10.0
        case .thirtySeconds:
            return 30.0
        case .sixtySeconds:
            return 60.0
        }
    }
}
