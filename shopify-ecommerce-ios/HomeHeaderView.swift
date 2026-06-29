//
//  HomeHeaderView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 27/06/2026.
//

import SwiftUI

struct HomeHeaderView: View {
    @State var searchText = ""
    var body: some View {
        VStack{
            HStack(){
                Button{
                    
                }label: {
                    Image("lines-icon").foregroundStyle(.black)
                }
                Spacer()
                
                HStack{
                    Image("logo")
                    Text("Stylish").font(.title2).fontWeight(.bold).foregroundStyle(Color(
                        red: 67 / 255,
                        green: 146 / 255,
                        blue: 249 / 255
                    ))
                }
                Spacer()
                
                Button{
                    
                }label: {
                    Image("profile")
                        .resizable().frame(width: 40,height: 40)
                        .clipShape(Circle())
                }
                
            }.padding(.horizontal,14)
            SearchField(searchText: $searchText).padding(16)
        
        }
    }
}

#Preview {
    HomeHeaderView(searchText: "")
}
