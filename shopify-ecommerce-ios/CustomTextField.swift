//
//  SwiftUIView.swift
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


struct CustomTextField: View {
    let placeholder : String
    let type: TextFieldtype
    let hasError : Bool
    var errorMessage : String? = nil
    
    @Binding var text: String
    @State private var isSecure = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
                HStack(spacing: 12){
                    Image(systemName: type.icon).foregroundStyle(Color(.darkGray)).font(.title2)
                    
                    Group{
                        if(type == .password && isSecure){
                            SecureField(placeholder, text: $text)
                        }
                        else{
                            TextField(placeholder, text: $text)
                        }
                    }.keyboardType(type.keyboardType)
                    
                    if(type == .password){
                        Button{
                            isSecure.toggle()
                        }label: {
                            Image(systemName: isSecure ? "eye.slash" : "eye").foregroundStyle(Color(.darkGray))
                        }.buttonStyle(.plain).font(.title2)
                    }
                }.padding()
                    .frame(height: 70)
                    .background (Color(white: 0.95))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                hasError ? .red : .black,
                                lineWidth: 0.5)
                    }
                    if hasError , let errorMessage{
                        Text(errorMessage).font(.caption)
                            .foregroundStyle(.red)
                            .padding(.leading,4)
                    }
        }.padding(.horizontal)
    }
}

#Preview {
    @State  var name = ""
    CustomTextField(
        placeholder: "Password",
        type: .password,
        hasError:false,
        errorMessage: "Invalid password",
        text: $name
    )
}
