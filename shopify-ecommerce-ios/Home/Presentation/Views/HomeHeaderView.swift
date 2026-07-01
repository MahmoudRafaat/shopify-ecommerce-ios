//
//  HomeHeaderView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 27/06/2026.
//

import SwiftUI

struct HomeHeaderView: View {
    @State var searchText = ""
    let categories : [Category]
    var body: some View {
        VStack(){
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
            HStack(){
                Text("All Featured").font(.title2).fontWeight(.semibold)
                Spacer()
                ActionChipButton(title: "Sort", systemImage: "sort-icon"){
                    print("sort")
                }
                ActionChipButton(title: "Filter", systemImage: "filter-icon"){
                    print("filter")
                }
            }.padding(.horizontal, 16)
            CategoriesSectionView(categories: categories).padding(.top,16)
        }
    }
}

#Preview {
    let categories = [
        Category(id: 1,title: "Beauty", imageName: "category-image"),
        Category(id: 2,title: "Fashion", imageName: "category-image"),
        Category(id: 3,title: "Kids", imageName: "category-image"),
        Category(id: 4,title: "Mens", imageName: "category-image"),
        Category(id: 5,title: "Womens", imageName: "category-image")
    ]
    HomeHeaderView(searchText: "",categories: categories)
}
