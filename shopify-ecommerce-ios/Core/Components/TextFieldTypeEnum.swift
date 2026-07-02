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
    
    var icon: String{
        switch self{
        case .name:
            return "person.fill"
        case .email:
            return "envelope.fill"
        case .password:
            return "lock.fill"
        }
    }
    
    var keyboardType : UIKeyboardType{
        switch self{
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }
    
}
