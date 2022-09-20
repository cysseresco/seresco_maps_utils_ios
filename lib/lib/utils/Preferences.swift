//
//  Preferences.swift
//  SerescoMapsUtils
//
//  Created by Diego Salcedo on 19/08/22.
//  Copyright © 2022 Seresco. All rights reserved.
//

import Foundation

struct Preferences {
    
    static var shared: Preferences = {
        let instance = Preferences()
        return instance
    }()
    
    func saveCoordinates(coords: [[Double]]?) {
        UserDefaults.standard.set(coords, forKey: Constants.COORDS_DATA)
    }
    
    func getCoordinates() -> [[Double]] {
        let coords = UserDefaults.standard.array(forKey: Constants.COORDS_DATA) as? [[Double]]
        return coords ?? []
    }
}
