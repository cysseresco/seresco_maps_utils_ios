//
//  ColorType.swift
//  SerescoMapsUtils
//
//  Created by Diego Salcedo on 15/08/22.
//  Copyright © 2022 Seresco. All rights reserved.
//

import UIKit

public enum ColorType {
    case colorRed, colorYellow, colorBlue, colorSkyBlue, colorGreen, colorBrown
    public var colorHex: String {
        switch self {
        case .colorRed:
            return "#FF0000"
        case .colorYellow:
            return "#ffc800"
        case .colorBlue:
            return "#2d37f3"
        case .colorSkyBlue:
            return "#2dacf3"
        case .colorGreen:
            return "#48a644"
        case .colorBrown:
            return "#a16d60"
        }
    }
    public var color: UIColor {
        switch self {
        case .colorRed:
            return .red ?? UIColor.black
        case .colorYellow:
            return .yellow ?? UIColor.black
        case .colorBlue:
            return .blue ?? UIColor.black
        case .colorSkyBlue:
            return .skyBlue ?? UIColor.black
        case .colorGreen:
            return .green ?? UIColor.black
        case .colorBrown:
            return .brown ?? UIColor.black
        }
    }
}
