//
//  MenuItem.swift
//  orderaturban2
//
//  Created by Robert Kovbasiuk on 01/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation

struct MenuItem: Identifiable, Hashable{
    //random id to satisfy identifiable
    var id = UUID()
    
    
    let name:String
    let price:Double
    let imgURL:String
    
    #warning ("add description")
    
    
}
