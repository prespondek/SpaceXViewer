//
//  Flight.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 5/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

struct Launch : Codable {
    let flightNumber: Int?
    let missionName: String?
    let launchSuccess: Bool?
    let launchYear: String?
}
