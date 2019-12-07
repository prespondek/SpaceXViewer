//
//  LaunchDetail.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 7/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

struct RocketDetail : Decodable {
    let id: String?
    let name: String?
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "rocket_id"
        case name = "rocket_name"
        case link = "wikipedia"
    }
}

struct Rocket : Decodable {
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "rocket_id"
    }
    init(from decoder: Decoder) throws {
        let container =     try decoder.container(keyedBy: CodingKeys.self)
        id =         try container.decodeIfPresent(String.self, forKey: .id)
    }
}

struct LaunchDetail : Decodable {
    let flightNum: Int?
    let missionName: String?
    let launchSuccess: Bool?
    var launchDate: Double?
    var details: String?
    let rocket: Rocket?
    
    enum CodingKeys: String, CodingKey {
        case flightNum = "flight_number"
        case missionName = "mission_name"
        case launchSuccess = "launch_success"
        case launchDate = "launch_date_unix"
        case rocket = "rocket"
        case details = "details"
    }
    
    init(from decoder: Decoder) throws {
        let container =     try decoder.container(keyedBy: CodingKeys.self)
        flightNum =         try container.decodeIfPresent(Int.self, forKey: .flightNum)
        missionName =       try container.decodeIfPresent(String.self, forKey: .missionName)
        launchSuccess =     try container.decodeIfPresent(Bool.self, forKey: .launchSuccess)
        launchDate =        try container.decodeIfPresent(Double.self, forKey: .launchDate)
        rocket =            try container.decodeIfPresent(Rocket.self, forKey: .rocket)
        details =           try container.decodeIfPresent(String.self, forKey: .details)
    }
}
