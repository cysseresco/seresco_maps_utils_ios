//
//  WmsUtils.swift
//  SerescoMapsUtils
//
//  Created by diegitsen on 17/02/23.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils
import CoreLocation

public class WmsUtils {
    
    public init() {}
    public var currentViewController: UIViewController?
    public var googleMap: GMSMapView?
    
    public func openWmsPanel() {
        let wmsSheet = WmsSheetViewController()
        wmsSheet.delegate = self
        currentViewController?.present(wmsSheet, animated: true, completion: nil)
    }
    
    public func setWmsLayer(wmsItem: WMSItem) {
        let layer: WMSTileOverlay = WMSTileOverlay(urlArg: "")
        
        guard let mapView = googleMap else {
            return
        }
        let urls: GMSTileURLConstructor = { (x: UInt, y: UInt, zoom: UInt) -> URL in
            let bbox = layer.bboxFromXYZ(x, y: y, z: zoom)
            let urlKN = "\(wmsItem.baseUrl)?layers=\(wmsItem.layer)&STYLES=&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&srs=EPSG:3857&width=256&height=256&format=image/png&transparent=true&BBOX=\(bbox.left),\(bbox.bottom),\(bbox.right),\(bbox.top)&CQL_FILTER=id_explotacion%20%3D%201303&CRS=EPSG:3857"
            print("URL: \(urlKN)")
            return URL(string: urlKN)!
        }
        
        let tileLayer = GMSURLTileLayer(urlConstructor: urls)
        tileLayer.opacity = 0.75
        
        tileLayer.map = nil
        tileLayer.map = mapView
    }
    
    public func setWmsLayerCleared(wmsItem: WMSItem) {
        let layer: WMSTileOverlay = WMSTileOverlay(urlArg: "")
        
        guard let mapView = googleMap else {
            return
        }
        mapView.clear()
        let urls: GMSTileURLConstructor = { (x: UInt, y: UInt, zoom: UInt) -> URL in
            let bbox = layer.bboxFromXYZ(x, y: y, z: zoom)
            let urlKN = "\(wmsItem.baseUrl)?layers=\(wmsItem.layer)&STYLES=&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&srs=EPSG:3857&width=256&height=256&format=image/png&transparent=true&BBOX=\(bbox.left),\(bbox.bottom),\(bbox.right),\(bbox.top)&CQL_FILTER=id_explotacion%20%3D%201303&CRS=EPSG:3857"
            print("URL: \(urlKN)")
            return URL(string: urlKN)!
        }
        
        let tileLayer = GMSURLTileLayer(urlConstructor: urls)
        tileLayer.opacity = 0.75
        
        tileLayer.map = nil
        tileLayer.map = mapView
    }
    
    public func setWmsLayer(wmsUrl: String) {
        let layer: WMSTileOverlay = WMSTileOverlay(urlArg: "")
        
        guard let mapView = googleMap else {
            return
        }
        
        let urls: GMSTileURLConstructor = { (x: UInt, y: UInt, zoom: UInt) -> URL in
            let bbox = layer.bboxFromXYZ(x, y: y, z: zoom)
            let urlKN = "\(wmsUrl)&BBOX=\(bbox.left),\(bbox.bottom),\(bbox.right),\(bbox.top)"

            return URL(string: urlKN)!
        }
        
        let tileLayer = GMSURLTileLayer(urlConstructor: urls)
        tileLayer.opacity = 0.75
        
        tileLayer.map = nil
        tileLayer.map = mapView
    }
    
    public func showSavedWmsLayers() {
        let wmsItems = Preferences.shared.getWmsItems()
        wmsItems.forEach { wmsItem in
            setWmsLayer(wmsUrl: wmsItem.urlEpsg900913)
        }
    }
    
}

extension WmsUtils: WmsOptionDelegate {
    public func deselectWmsOption(wmsItem: WMSItem) {
        let preferences = Preferences.shared
        preferences.removeWmsItem(item: wmsItem)
        
        let selectedWmsItems: [WMSItem] = preferences.getWmsItems()
        selectedWmsItems.forEach { wmsItem in
            setWmsLayer(wmsItem: wmsItem)
        }
    }
    
    public func selectWmsOption(wmsItem: WMSItem) {
        let preferences = Preferences.shared
        preferences.addWmsItem(item: wmsItem)
        setWmsLayer(wmsItem: wmsItem)
    }
}

