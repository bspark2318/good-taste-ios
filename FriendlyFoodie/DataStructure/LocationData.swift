//
//  LocationData.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import Foundation

// Location Data Structure 
struct LocationData : Hashable{
    var id: Int
    var name: String
    var description: String
    var lat : Double
    var long : Double
    var hour : String
    var address : String
    var picture: String
    var endorsement : [String]
}
