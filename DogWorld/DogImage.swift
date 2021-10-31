//
//  DogImage.swift
//  DogWorld
//
//  Created by BarisOdabasi on 6.03.2021.
//

import Foundation

struct DogImage: Codable {
    
    // MARK: - Properties
    var status: String
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case imageURL = "message"
    }
}
