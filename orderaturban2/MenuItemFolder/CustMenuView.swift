//
//  HomeView.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI


//purpose of the struct is to display rows of menu items which are categorised.
//Called in: Home
struct CustMenuView: View  {
    
    @ObservedObject var appData: RTData
    
    var body: some View {
        VStack {
            Text("Order @ Urban")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color("primGreen"))
            
            
            NavigationView{
                
                //dynamically creates a SectionMenuItem row from categories data array
                //each row contains data from the relevant SectionMenuItem
                //forEach var in the array it returns a MenuItemRow
                
                List(self.appData.categoriesData) { (object) -> MenuItemRow in
                    return MenuItemRow(menuItems: object.items, categoryName: object.name())
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
