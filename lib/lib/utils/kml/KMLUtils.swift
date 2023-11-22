//
//  KMLUtils.swift
//  SerescoMapsUtils
//
//  Created by Diego Salcedo on 10/08/22.
//  Copyright © 2022 Seresco. All rights reserved.
//

import Foundation
import GoogleMapsUtils
import CodableGeoJSON
import UIKit

public class KMLUtils: UIViewController, GMSMapViewDelegate {
    
    var currentStrokeColor = UIColor.darkGray
    var currentFillColor = UIColor.clear
    
    public func retrieveKml(map: GMSMapView, resource: String, strokeColor: UIColor, fillColor: UIColor, strokeWidth: CGFloat, completion: @escaping (Result<GMUGeometryRenderer,Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            return completion(.failure(KmlUtilsError.invalidResource))
        }
        let url = URL(fileURLWithPath: path)
        let geoJsonParser = GMUGeoJSONParser(url: url)
        geoJsonParser.parse()
        let style = GMUStyle(styleID: "kmlStyle",
                             stroke: strokeColor,
                             fill: fillColor,
                             width: strokeWidth,
                             scale: 1,
                             heading: 0,
                             anchor: CGPoint(x: 0, y: 0),
                             iconUrl: nil,
                             title: nil,
                             hasFill: true,
                             hasStroke: true)

        for feature in geoJsonParser.features {
          feature.style = style
        }
        map.delegate = self
        let render = GMUGeometryRenderer(map: map, geometries: geoJsonParser.features)
        return completion(.success(render))
    }
    
    public func retrieveKml(map: GMSMapView, pathResource: String, strokeColor: UIColor, fillColor: UIColor, strokeWidth: CGFloat) -> GMUGeometryRenderer {
        let path = Bundle.main.path(forResource: pathResource, ofType: "json") ?? ""
        let url = URL(fileURLWithPath: path)
        let geoJsonParser = GMUGeoJSONParser(url: url)
        geoJsonParser.parse()
        let style = GMUStyle(styleID: "kmlStyle",
                             stroke: strokeColor,
                             fill: fillColor,
                             width: strokeWidth,
                             scale: 1,
                             heading: 0,
                             anchor: CGPoint(x: 0, y: 0),
                             iconUrl: nil,
                             title: nil,
                             hasFill: true,
                             hasStroke: true)

        for feature in geoJsonParser.features {
          feature.style = style
        }
        map.delegate = self
        let render = GMUGeometryRenderer(map: map, geometries: geoJsonParser.features)
        return render
    }
    
    public func retrieveKml(map: GMSMapView, coordinates: [[Double]], strokeColor: UIColor, fillColor: UIColor, strokeWidth: CGFloat) -> GMUGeometryRenderer? {
        let resource = "{ \"type\": \"FeatureCollection\", \"features\": [ {  \"type\": \"Feature\", \"properties\": {}, \"geometry\": {  \"type\": \"LineString\",  \"coordinates\": \(coordinates) } } ] }"
        guard let data = resource.data(using: .utf8) else {
            return nil
        }
        let geoJsonParser = GMUGeoJSONParser(data: data)
        geoJsonParser.parse()
        let style = GMUStyle(styleID: "kmlStyle",
                             stroke: strokeColor,
                             fill: fillColor,
                             width: strokeWidth,
                             scale: 1,
                             heading: 0,
                             anchor: CGPoint(x: 0, y: 0),
                             iconUrl: nil,
                             title: nil,
                             hasFill: true,
                             hasStroke: true)

        for feature in geoJsonParser.features {
          feature.style = style
        }
        map.delegate = self
        return GMUGeometryRenderer(map: map, geometries: geoJsonParser.features)
    }
    
    
}
