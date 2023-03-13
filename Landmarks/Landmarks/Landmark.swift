//
//  Landmark.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/13.
//

import Foundation

struct Landmark: Hashable, Codable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
}
