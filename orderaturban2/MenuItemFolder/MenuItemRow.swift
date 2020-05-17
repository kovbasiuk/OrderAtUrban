//
//  MenuItemRow.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import SwiftUI

//Row of MenuItems used in CustMenuView
struct MenuItemRow: View {
    
    
    var menuItems:[MenuItem]
    let categoryName:String
    var body: some View {
        
        Group{
            
            VStack(){
                Text(self.categoryName)
                    .font(.title)
                    .foregroundColor(Color("primGreen"))
                
                VStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(alignment: .top) {
                            
                            ForEach (menuItems, id: \.name){ menuItem in
                                
                                
                                
                                NavigationLink(destination: MenuItemDetail(menuItem: menuItem)){
                                    
                                    MenuItemRowComponent(menuItem: menuItem)
                                        .padding(.leading, 110.0)
                                        .frame(width: 300)
                                    
                                }
                            }
                        }
                    }
                }
            }//.padding(.leading, 40)
        }
        
    }
    
    
}


struct MenuItemRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemRow(menuItems: TestData.testMenuItem, categoryName: "random")
    }
}
