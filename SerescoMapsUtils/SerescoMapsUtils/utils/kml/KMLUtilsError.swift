//
//  KMLUtilsError.swift
//  TestLibs
//
//  Created by Diego Salcedo on 10/08/22.
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
