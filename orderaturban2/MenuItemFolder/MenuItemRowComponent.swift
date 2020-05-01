//
//  MenuItemRowComponent.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//


import SwiftUI

import struct Kingfisher.KFImage



/*
Struct is to make any adjustments to the image
*/
struct MenuItemRowComponentIMG: View {
    
   let menuItem:MenuItem
 
    
    //method to avoid immatability
    func getItemURL() -> URL {
       
   return URL(
    string: menuItem.imgURL)!
        
     }
    
    //Note for future: check kingfisher uisupport for ways to make more efficient
    var body: some View {
        KFImage(getItemURL())
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 170)
            .cornerRadius(10)
            .shadow(radius: 5)
        
        
    }
}

/*
Struct is a component of row which displays a preview of all estbalishments horizonally in the Row file
*/

struct MenuItemRowComponent: View {
    
  let menuItem:MenuItem
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16.0){
            
            
           
            MenuItemRowComponentIMG(menuItem: menuItem)
               
            
             VStack(alignment: .leading, spacing: 5.0){
                Text(menuItem.name)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
                Text("ADD DESCRIPTION HERE")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .frame(height: 40)
            
            }
            
            
            //first vstack
        } .padding(.trailing, 100.0)
        
        
    }
}

struct MenuItemRowComponent_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemRowComponent(menuItem: MenuItem(name: "Coffee", price: 2.2, imgURL: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2020/04/11/16/istock-1213958021.jpg?w968h681"))
    }
}
