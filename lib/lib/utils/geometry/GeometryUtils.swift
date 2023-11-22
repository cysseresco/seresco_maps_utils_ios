//
//  GeometryUtils.swift
//  SerescoMapsUtils
//
//  Created by diegitsen on 22/11/23.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

class GeometryUtils: NSObject {
    
    public var googleMap: GMSMapView
    public var polygon: [CLLocationCoordinate2D] = []
    public var polygons: [[CLLocationCoordinate2D]] = []
    public var finishInListOfPolygonCallback: (([[CLLocationCoordinate2D]]) -> Void)?
    public var finishInPolygonCallback: (([CLLocationCoordinate2D]) -> Void)?
    public var intersections: [[CLLocationCoordinate2D]] = []
    
    public override init() {
        self.googleMap = GMSMapView()
        super.init()
    }
    
    public init(googleMap: GMSMapView, polygon: [CLLocationCoordinate2D]) {
        self.googleMap = googleMap
        self.polygon = polygon
    }
    
    public init(googleMap: GMSMapView, polygons: [[CLLocationCoordinate2D]]) {
        self.googleMap = googleMap
        self.polygons = polygons
    }
    
    var coordinatesTapped: [CLLocationCoordinate2D] = []
    var startPolygon = false
 
    public func drawIntersectionInPolygon(coordinatesPolygon: [CLLocationCoordinate2D], polygonDrawed: GMSPolygon) {
        var coordinatesDottedInPolygon = [CLLocationCoordinate2D]()
        for x in 0..<(coordinatesPolygon.count - 1) {
            let line = Line(p1: coordinatesPolygon[x], p2: coordinatesPolygon[x+1])
            let points = line.getPoints(quantity: 30)
            coordinatesDottedInPolygon.append(contentsOf: points)
        }

        var intersects: [CLLocationCoordinate2D] = []
        coordinatesDottedInPolygon.forEach { coordinate in
            if polygonDrawed.contains(coordinate: coordinate) {
                intersects.append(coordinate)
            }
        }
        intersections.append(intersects)
        
        let mutablePath = GMSMutablePath()
        intersects.forEach { coordinate in
            mutablePath.add(coordinate)
        }
    
        let polygon = GMSPolygon(path: mutablePath)
        polygon.fillColor = .blue
        polygon.strokeColor = .purple
        polygon.strokeWidth = 3
        polygon.map = googleMap
    }
    
    
}

extension GeometryUtils: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        coordinatesTapped.append(coordinate)
        
        if (!startPolygon) {
            let marker = GMSMarker()
            marker.position = coordinate
            marker.icon = UIImage(systemName: "circle.circle")
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
        } else {
            polygons.forEach { polygonCoordinates in
                drawIntersectionInPolygon(coordinatesPolygon: polygonCoordinates, polygonDrawed: polygonDrawed)
            }
            finishInListOfPolygonCallback?(intersections)
        }
        
        coordinatesTapped = []
        intersections = []
        
        return true
    }
}

