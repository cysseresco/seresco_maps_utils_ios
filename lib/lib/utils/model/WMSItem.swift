//
//  WMSItem.swift
//  SerescoMapsUtils
//
//  Created by diegitsen on 19/02/23.
//

import Foundation

public struct WMSItem: Codable {
    let baseUrl: String
    let layer: String
    let description: String
}

extension WMSItem {
    var urlEpsg900913: String {
        let url = "\(baseUrl)&request=GetMap&layers=\(layer)&width=256&height=256&srs=EPSG:900913&format=image/png&transparent=true"
        return url
    }
    var urlEpsg23031: String {
        let url = "\(baseUrl)&request=GetMap&layers=\(layer)&width=256&height=256&srs=EPSG:23031&format=image/png&transparent=true"
        return url
    }
}
