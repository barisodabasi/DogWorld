//
//  BreedListResponse.swift
//  DogWorld
//
//  Created by BarisOdabasi on 6.03.2021.
//

import Foundation

struct BreedListResponse: Codable {
    
    // MARK: - Properties
    var status: String
    var message: [String : [String]]
}
