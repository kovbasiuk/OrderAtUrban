//
//  HomeView.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI

struct CustMenuView: View  {
 
    
    var hotDrinks:[MenuItem]
    var coldDrinks:[MenuItem]
    var hotFood:[MenuItem]
    var coldFood:[MenuItem]
    var deserts:[MenuItem]
        
    var body: some View {
        VStack {
            Text("Order @ Urban")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color("primGreen"))
                .padding(.top, 30)
            NavigationView{
                
            ScrollView(.vertical, showsIndicators: false){
            VStack {
                if !hotDrinks.isEmpty {
                  MenuItemRow(menuItems: hotDrinks, categoryName: "Hot Drinks")
                }
                
                if !hotFood.isEmpty {
                MenuItemRow(menuItems: hotFood, categoryName: "Hot Food")
                }

                if !coldDrinks.isEmpty {
                  MenuItemRow(menuItems: coldDrinks, categoryName: "Cold Drinks")
                }


          if !coldFood.isEmpty {
            MenuItemRow(menuItems: coldFood, categoryName: "Cold Food")
          }

                if !deserts.isEmpty {
                  MenuItemRow(menuItems: deserts, categoryName: "Deserts")
                }
    
        
             
            }.frame(width: UIScreen.main.bounds.size.width)
            }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
       CustMenuView(hotDrinks: TestData.testMenuItem, coldDrinks: TestData.testMenuItem, hotFood: TestData.testMenuItem, coldFood: TestData.testMenuItem, deserts: TestData.testMenuItem)
        
       // HomeView()
    }
}
