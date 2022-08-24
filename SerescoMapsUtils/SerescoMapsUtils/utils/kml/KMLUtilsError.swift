//
//  KMLUtilsError.swift
//  SerescoMapsUtils
//
//  Created by Diego Salcedo on 10/08/22.
//  Copyright © 2022 Seresco. All rights reserved.
//

import Foundation

public enum KmlUtilsError: LocalizedError {
    case invalidResource
    
    public var errorDescription: String? {
        switch self {
        case .invalidResource: return "El recurso brindado para obtener el json es inválido"
        }
    }
}
