//
//  GeometryUtils.swift
//  SerescoMapsUtils
//
//  Created by diegitsen on 22/11/23.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

extension GeometryUtils: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        coordinatesTapped.append(coordinate)
        
        if (!startPolygon) {
            let marker = GMSMarker()
            marker.position = coordinate
            if #available(iOS 13.0, *) {
                marker.icon = UIImage(systemName: "circle.circle")
            } else {
                marker.icon = UIImage(named: "circle.circle")
            }
            marker.map = googleMap
            startPolygon = true
        }
       
        let polygonPath = GMSMutablePath()
        coordinatesTapped.forEach { coordinate in
            polygonPath.add(coordinate)
        }
        
        let polyline = GMSPolyline(path: polygonPath)
        polyline.strokeColor = .redStepperColor
        polyline.strokeWidth = 3
        polyline.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        startPolygon = false
        coordinatesTapped.append(marker.position)
        
        let rect = GMSMutablePath()
        coordinatesTapped.forEach { coordinate in
            rect.add(coordinate)
        }
        
        let polygonDrawed = GMSPolygon(path: rect)
        polygonDrawed.fillColor = .yellowStrokeColor.withAlphaComponent(0.5)
        polygonDrawed.strokeColor = .redStepperColor
        polygonDrawed.strokeWidth = 3
        polygonDrawed.map = mapView
        
        if polygons.isEmpty {
            drawIntersectionInPolygon(coordinatesPolygon: polygon, polygonDrawed: polygonDrawed)
            finishInPolygonCallback?(intersections.first ?? [])
            finishDrawingOfPolygon()
        } else {
            polygons.forEach { polygonCoordinates in
                drawIntersectionInPolygon(coordinatesPolygon: polygonCoordinates, polygonDrawed: polygonDrawed)
            }
            finishInListOfPolygonCallback?(intersections)
            finishDrawingOfPolygon()
        }
        
        coordinatesTapped = []
        intersections = []
        
        return true
    }
}
