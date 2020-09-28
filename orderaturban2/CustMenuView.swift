//
//  HomeView.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI


//purpose of the struct is to display rows of menu items which are categorised.
//Used in: Home
struct CustMenuView: View  {
    
    @ObservedObject var appData: RTData
    
    var body: some View {
        VStack {
            Text("Order @ Urban")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color("primGreen"))
            
            //dynamically creates a scroll view on the different catories of rows containing menu items
            if !self.appData.categoriesData.isEmpty{
                NavigationView{
                    ScrollView(.vertical, showsIndicators: false){
                        ForEach (self.appData.categoriesData, id: \.type){ categoryItem in
                            
                            return MenuItemRow(menuItems: categoryItem.items, categoryName: categoryItem.name())
                        }
                    }
                }
            }
        }
        
    }
}


//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        let items = Dictionary(grouping: TestData.testMenuItem) { $0.type }
//        return CustMenuView(categoriesData: items)
//        // HomeView()
//    }
//}
