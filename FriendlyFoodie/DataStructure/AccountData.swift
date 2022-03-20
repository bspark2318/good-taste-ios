//
//  AccountData.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import Foundation

// Account  Data Structure 
struct AccountData : Hashable {
    var id: String
    var first_name: String
    var last_name: String
    var profile_pic: String
    var description: String
    var year_joined: Int
    var endorsed_places : [Int]
}
