//
//  TrackingUtils.swift
//  SerescoMapsUtils
//
//  Created by Diego Salcedo on 19/08/22.
//  Copyright © 2022 Seresco. All rights reserved.
//

import GoogleMapsUtils
import UIKit

public protocol TrackingUtilsDelegate {
    func showTrackCoordinates(coordinates: [[Double]])
}

public class TrackingUtils {
    
    public init() {}
    public var currentViewController: UIViewController?
    public var delegate: TrackingUtilsDelegate?
    let kmlUtils = KMLUtils()
    let preferences = Preferences.shared
    
    public func openTrackingPanel() {
        let trackingSheet = TrackingSheetViewController()
        trackingSheet.delegate = self
        currentViewController?.present(trackingSheet, animated: true, completion: nil)
    }
    
    public func showSavedCoordinates(googleMap: GMSMapView) {
        googleMap.clear()
        let coordinates = preferences.getCoordinates()
        if coordinates.first?.isEmpty == false {
            let geometryRenderer = kmlUtils.retrieveKml(map: googleMap, coordinates: coordinates, strokeColor: UIColor.yellow, fillColor: UIColor.green, strokeWidth: 3)
            geometryRenderer?.render()
        }
        // setOnClickListener
        // marker
        // stroke color
    }
}

extension TrackingUtils: TrackingSheetDelegate {
    public func sendCoordinates(coordinates: [[Double]]) {
        delegate?.showTrackCoordinates(coordinates: coordinates)
    }
}
