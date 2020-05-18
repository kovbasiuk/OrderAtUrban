//
//  SectionMenuItem.swift
//  orderaturban2
//
//  Created by by Robert Kovbasiuk on 09/05/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation



//purpose of this struct is to categorise a row of menu items by storing items of the same category
//Used in: RTData
struct SectionMenuItem: Identifiable, Hashable {

    var id = UUID()
    let type: String
    let items: [MenuItem]
    
    //used to satisfy Hashable
      func hash(into hasher: inout Hasher) {
          hasher.combine(id)
    }
    
    //Returns a String to be displayed representing the category in a simpler way. This is because the type is set by the variable names in Firestore which follow a camelCase style
    //Used in: CustMenuView
    func name() -> String {
        switch type {
        case "hotDrinks": return "Hot Drinks"
        case "coldDrinks": return "Cold Drinks"
        case "hotFood": return "Hot Food"
        case "deserts": return "Deserts"
        case "coldFood": return "Cold Food"
        default:
            return "Other"
        }
    }
}




