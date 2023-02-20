Pod::Spec.new do |spec|

  spec.name         = "SerescoMapsUtils"
  spec.version      = "0.0.5"
  spec.summary      = "A framework which contains functionalities about GoogleMaps"
  spec.description  = "A framework that has functionalities in KML, Markers, tracking and much more! using GoogleMaps"

  spec.homepage     = "https://github.com/cysseresco/seresco_maps_utils_ios"
  spec.license      = "MIT"
  spec.author             = { "diego" => "92336377+diegosalcedov@users.noreply.github.com" }
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/cysseresco/seresco_maps_utils_ios.git", :tag => spec.version.to_s }
  spec.source_files  = "lib/**/**"
  spec.swift_versions = "5.0"
  spec.requires_arc          = true
  spec.static_framework = true
  #spec.dependency 'GoogleMaps', '~> 3'
  spec.dependency 'Google-Maps-iOS-Utils', '3.10.3'
  spec.dependency 'CodableGeoJSON'
  spec.ios.deployment_target = '9.0'

  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end