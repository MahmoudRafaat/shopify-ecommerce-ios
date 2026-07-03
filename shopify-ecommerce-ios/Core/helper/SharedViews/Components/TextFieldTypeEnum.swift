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
    case address
    case number
    case phone
    var icon: String{
        switch self{
        case .name:
            return "person.fill"
        case .email:
            return "envelope.fill"
        case .password:
            return "lock.fill"
        case .address: return "mappin.and.ellipse"
                case .number: return "number.circle.fill"
        case .phone:
            return "phone.fill"
        }
    }
    
    var keyboardType : UIKeyboardType{
        switch self{
        case .email:
            return .emailAddress
        case .number: return .numberPad
        case .phone:
            return .phonePad
        default:
            return .default
        }
    }
    
}
