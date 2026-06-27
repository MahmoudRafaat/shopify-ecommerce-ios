//
//  OnboardingPage.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 12/01/1448 AH.
//

import Foundation

enum OnboardingPage : Int, CaseIterable {
    case chooseProducts, makePayment, getYourOrder
    
    var image: String {
        switch self {
        case .chooseProducts:
            return "onboarding-image-1"
        case .makePayment:
            return "onboarding-image-2"
        case .getYourOrder:
            return "onboarding-image-3"
        }
    }
    
    var title : String {
        switch self {
        case .chooseProducts:
            return "Choose Product"
        case .makePayment:
            return "Make Payment"
        case .getYourOrder:
            return "Get Your Order"
        }
    }
    
    var description : String {
        switch self {
        case .chooseProducts:
            return "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit."
        case .makePayment:
            return "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit."
        case .getYourOrder:
            return "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit."
        }
    }
}
