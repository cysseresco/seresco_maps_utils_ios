Seresco Maps Utils iOS
=======

## Description

A maps utils library for iOS using Google Maps Api

- **Tracking**
- **KML**
- **Cluster**
- **Markers**

<p float="left">
  <img src="Art/img_change_opacity.png" width="200" height="450">
  <img src="Art/img_update_border.png" width="200" height="450">
  <img src="Art/img_show_info.png" width="200" height="450">
  <img src="Art/img_manual_tracking.png" width="200" height="450">
</p>

Usage
--------

e.g. Displaying Tracking Panel

```swift
import SerescoMapsUtils


let trackingUtils = TrackingUtils()

func openTrackingPanel() {
    trackingUtils.currentViewController = self
    trackingUtils.openTrackingPanel()
}

func showTrackedRoute() {
    trackingUtils.showSavedCoordinates(googleMap: self.mapView)
}
```

Installation
--------

#### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
  pod 'SerescoMapsUtils', '~> 1.0'
end
```
