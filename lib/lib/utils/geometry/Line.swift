//
//  Line.swift
//  SerescoMapsUtils
//
//  Created by diegitsen on 22/11/23.
//

import UIKit
import GoogleMapsUtils

class Line {
    private let p1: CLLocationCoordinate2D
    private let p2: CLLocationCoordinate2D
    
    init(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D) {
        self.p1 = p1
        self.p2 = p2
    }
    
    func getPoints(quantity: Int) -> [CLLocationCoordinate2D] {
        var points = [CLLocationCoordinate2D?](repeating: nil, count: quantity)
        let ydiff = p2.latitude - p1.latitude
        let xdiff = p2.longitude - p1.longitude
        let slope = Double(p2.latitude - p1.latitude) / (p2.longitude - p1.longitude)
        var x: Double
        var y: Double
        var i = 0.0
        while i < Double(quantity) {
            y = slope == 0.0 ? 0.0 : ydiff * (i / Double(quantity))
            x = slope == 0.0 ? xdiff * (i / Double(quantity)) : y / slope
            points[Int(i)] = CLLocationCoordinate2D(latitude: y + p1.latitude, longitude: x + p1.longitude)
            i += 1
        }
        points[quantity - 1] = p2
        return points.compactMap { $0 }
    }
}
