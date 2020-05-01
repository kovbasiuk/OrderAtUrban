//
//  MenuItemDetail.swift
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

//need to optimise to use 1 class
struct menuItemDetailIMG: View{
    
    //update to geometry reader in the future
    let menuItem:MenuItem
    
    //method to avoid immatability
    func getEstURL() -> URL {
        return URL(
            string: menuItem.imgURL)!
        
    }
    
    //check kingfisher uisupport for ways to make more efficient
    var body: some View {
        
        
        KFImage(getEstURL())
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.5)
            .cornerRadius(5)
            .shadow(radius: 5)
        
        
        
        
        
    }
}


struct MenuItemDetail: View {
    
    let menuItem:MenuItem
         
        // var appData:RTData
         
         
         func getEstName()->String{
             return menuItem.name
         }
         
         func getEvents(){
             
         }
         
         
    
    var body: some View {
        
        List{
            ZStack(alignment: .bottom) {
                //need to sort this out might be because its not in the iage struct
                menuItemDetailIMG(menuItem: menuItem)
                  
                Rectangle()
                    .padding(.trailing, 20.0)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/10)
                    .cornerRadius(20)
                    .opacity(0.5)
                    .blur(radius: 50)
                
                HStack{
                    VStack(alignment: .leading,spacing: 8){
                        Text(menuItem.name)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                        
                        //NEED OTO SORT THE PADDING OUT
                    }.padding(.trailing, 200.0)
                    
                    
                }
                .padding(.leading, 20)
                .padding(.bottom, 7)
                
            }
            .listRowInsets(EdgeInsets())
            VStack {
                Text(String(menuItem.price))
                    .foregroundColor(.primary)
                    .font(.body)
                    //.lineLimit(nil)
                    .padding(.top, 30.0)
                    .lineSpacing(12)
                 
                
                Button(action:{}){
                    Text("IDK WHAT TO DO HERE")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        
                        .padding(.horizontal, 110.0)
                }
               
                
            }
            .listRowInsets(EdgeInsets())
        }
            
     .edgesIgnoringSafeArea(.top)
     .navigationBarHidden(true)
    }
}

struct MenuItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemDetail(menuItem: MenuItem(name: "Coffee", price: 2.2, imgURL: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2020/04/11/16/istock-1213958021.jpg?w968h681"))
    }
}
