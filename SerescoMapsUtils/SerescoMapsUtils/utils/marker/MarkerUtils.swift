//
//  MarkerUtils.swift
//  TestLibs
//
//  Created by Diego Salcedo on 10/08/22.
//

import GoogleMapsUtils
import CodableGeoJSON
import UIKit

public protocol MarkerUtilsDelegate {
    func markerTapped(markerProperties: MarkerProperties)
}

public class MarkerUtils: UIViewController, GMSMapViewDelegate {
    
    
    public var delegate: MarkerUtilsDelegate?
    
    /// Muestra los markers dentro del mapa
    /// - Parameters:
    ///   - map: GoogleMap
    ///   - resource: path del recurso con el json
    ///   - icon: ícono del marker
    public func retrieveMarkers(map: GMSMapView, resource: String, icon: String) {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
          return
        }
        let markerImage = UIImage(named: icon)!.withRenderingMode(.alwaysOriginal)
        let url = URL(fileURLWithPath: path)
        map.delegate = self
        do {
            let markersData = try Data(contentsOf: url as URL)
            let locationFeatures = try JSONDecoder().decode(LocationFeatureCollection.self, from: markersData)
            for feature in locationFeatures.features {
                NSLog(feature.properties?.name ?? "default_value")
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: (feature.geometry?.coordinates.latitude)!, longitude:  (feature.geometry?.coordinates.longitude)!)
                marker.icon = self.image(markerImage, scaledToSize: CGSize(width: 25, height: 35))
                marker.title = feature.properties?.name
                marker.snippet = feature.properties?.snippet
                marker.map = map
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    fileprivate func image(_ originalImage:UIImage, scaledToSize:CGSize) -> UIImage {
         if originalImage.size.equalTo(scaledToSize) {
             return originalImage
         }
         UIGraphicsBeginImageContextWithOptions(scaledToSize, false, 0.0)
         originalImage.draw(in: CGRect(x: 0, y: 0, width: scaledToSize.width, height: scaledToSize.height))
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return image!
     }
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let markerProperties = MarkerProperties(name: marker.title ?? "", snippet: marker.snippet ?? "")
        delegate?.markerTapped(markerProperties: markerProperties)
        return true
    }
    
}

typealias LocationFeatureCollection = GeoJSONFeatureCollection<PointGeometry, MarkerProperties>
