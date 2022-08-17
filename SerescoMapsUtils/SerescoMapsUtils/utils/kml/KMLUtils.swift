//
//  KMLUtils.swift
//  TestLibs
//
//  Created by Diego Salcedo on 10/08/22.
//

import Foundation
import GoogleMapsUtils
import CodableGeoJSON
import UIKit

public class KMLUtils: UIViewController, GMSMapViewDelegate {
    
    var currentStrokeColor = UIColor.darkGray
    var currentFillColor = UIColor.clear
    
    /// Devuelve el objeto GMUGeometryRenderer para poder pintar los Kmls
    /// - Parameters:
    ///   - map: GoogleMap
    ///   - resource: path del recurso con el json
    ///   - strokeColor: color del borde
    ///   - fillColor: color del fondo
    ///   - strokeWidth: ancho del borde
    ///   - completion: callback
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
    
    /// Devuelve el objeto GMUGeometryRenderer para poder pintar los Kmls
    /// - Parameters:
    ///   - map: GoogleMap
    ///   - resource: path del recurso con el json
    ///   - strokeColor: color del borde
    ///   - fillColor: color del fondo
    ///   - strokeWidth: ancho del borde
    /// - Returns: GMUGeometryRenderer
    public func retrieveKml(map: GMSMapView, resource: String, strokeColor: UIColor, fillColor: UIColor, strokeWidth: CGFloat) -> GMUGeometryRenderer {
        let path = Bundle.main.path(forResource: resource, ofType: "json") ?? ""
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
}

