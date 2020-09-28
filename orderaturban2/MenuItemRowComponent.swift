//
//  MenuItemRowComponent.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//


import SwiftUI

import struct Kingfisher.KFImage



//purpose of this struct is to make any adjustments to the image
//Used in: MenuItemRowComponent
struct MenuItemRowComponentIMG: View {
    
    let menuItem:MenuItem
    
    
    //method to avoid "before self is available error"
    func getItemURL() -> URL {
        
        return URL(
            string: menuItem.imgURL)!
        
    }
    
 
    var body: some View {
       
        KFImage(getItemURL(), options: [
            .transition(.fade(0.6)),

        ])
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 170)
            .cornerRadius(10)
            .shadow(radius: 5)
        
        
    }
}


 //This struct is a component of row which displays a preview of a MenuItem in the MenuItemRow view with brief information about it
//Used in: MenuItemRow
struct MenuItemRowComponent: View {
    
    let menuItem:MenuItem
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16.0){
            
            
           
            
            MenuItemRowComponentIMG(menuItem: menuItem)
            
            Text(menuItem.name)
                           .font(.headline)
                           .multilineTextAlignment(.leading)
                           .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 5.0){
                
            
                Text(menuItem.desc)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .frame(height: 40)
            }
            
            HStack{
                Text("Prep Time:")
                .font(.subheadline)
                .foregroundColor(.secondary)
                Text("\(menuItem.prepTime)")
                    .foregroundColor(Color("secGreen"))
                
                //if prep time is more than 1 then minute
                //becomes plural -> minutes
                Text(menuItem.prepTime>1 ? "minutes" : "minute")
                    .foregroundColor(Color("secGreen"))
            }
            .multilineTextAlignment(.leading)
            
            
            //first vstack
        } .padding(.trailing, 70.0)
            .frame(width: 300)
        
        
    }
}

struct MenuItemRowComponent_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemRowComponent(menuItem:  MenuItem(name: "Cheese and beans panini", price: 2.5, imgURL: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2020/04/11/16/istock-1213958021.jpg?w968h681", prepTime: 1, description: "need to find something to write about here", type: "hotDrinks"))
    }
}
