//
//  TextFieldTypeEnum.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 27/06/2026.
//

import SwiftUI

enum TextFieldtype{
    case email
    case password
    case name
    case phone
    case address
    case city
    case country
    
    var icon: String{
        switch self{
        case .name:
            return "person.fill"
        case .email:
            return "envelope.fill"
        case .password:
            return "lock.fill"
        case .phone:
            return "phone.fill"
        case .address:
            return "map.fill"
        case .city:
            return "building.2.fill"
        case .country:
            return "globe"
        }
    }
    
    var keyboardType : UIKeyboardType{
        switch self{
        case .email:
            return .emailAddress
        case .phone:
            return .phonePad
        default:
            return .default
        }
    }
    
}
