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
    
    func saveWmsItems(items: [WMSItem]) {
        UserDefaults.standard.set(items, forKey: Constants.WMS_ITEMS_DATA)
    }
    
    func addWmsItem(item: WMSItem) {
        var savedItems = getWmsItems()
        savedItems.append(item)
        if let encoded = try? JSONEncoder().encode(savedItems) {
            UserDefaults.standard.set(encoded, forKey: Constants.WMS_ITEMS_DATA)
        }
    }
    
    func removeWmsItem(item: WMSItem) {
        let savedItems = getWmsItems().filter { $0.layer != item.layer }
        if let encoded = try? JSONEncoder().encode(savedItems) {
            UserDefaults.standard.set(encoded, forKey: Constants.WMS_ITEMS_DATA)
        }
    }
    
    func getWmsItems() -> [WMSItem] {
        if let data = UserDefaults.standard.object(forKey: Constants.WMS_ITEMS_DATA) as? Data,
           let wmsItems = try? JSONDecoder().decode(Array.self, from: data) as [WMSItem] {
             return wmsItems
        } else {
            return []
        }
    }
}
