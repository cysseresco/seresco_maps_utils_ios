Pod::Spec.new do |spec|

  spec.name         = "SerescoMapsUtils"
  spec.version      = "1.0.1"
  spec.summary      = "A framework which contains functionalities about GoogleMaps"
  spec.description  = "A framework that has functionalities in KML, Markers, tracking and much more! using GoogleMaps"

  spec.homepage     = "https://github.com/cysseresco/seresco_maps_utils_ios"
  spec.license      = "MIT"
  spec.author             = { "diego" => "92336377+diegosalcedov@users.noreply.github.com" }
  spec.platform     = :ios, "12.1"

  spec.source       = { :git => "https://github.com/cysseresco/seresco_maps_utils_ios.git", :tag => spec.version.to_s }
  spec.source_files  = "SerescoMapsUtils/**/**"
  spec.resources = 'SerescoMapsUtils/**/*.{storyboard,xib,xcassets,json,png}'
  spec.frameworks = "CodableGeoJSON", "CodableJSON", "GoogleMapsUtils", "GoogleMaps"
  spec.swift_versions = "5.0"

end
