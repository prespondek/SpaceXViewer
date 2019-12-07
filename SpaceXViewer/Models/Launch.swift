//
//  Flight.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 5/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

struct Launch : Decodable {
    let flightNum: Int?
    let missionName: String?
    let launchSuccess: Bool?
    let launchYear: String?
    
    enum CodingKeys: String, CodingKey {
        case flightNum = "flight_number"
        case missionName = "mission_name"
        case launchSuccess = "launch_success"
        case launchYear = "launch_year"
    }
    
    init(from decoder: Decoder) throws {
        let container =     try decoder.container(keyedBy: CodingKeys.self)
        flightNum =         try container.decodeIfPresent(Int.self, forKey: .flightNum)
        missionName =       try container.decodeIfPresent(String.self, forKey: .missionName)
        launchSuccess =     try container.decodeIfPresent(Bool.self, forKey: .launchSuccess)
        launchYear =        try container.decodeIfPresent(String.self, forKey: .launchYear)
    }
}
