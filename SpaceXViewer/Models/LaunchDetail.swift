//
//  LaunchDetail.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 7/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation

struct RocketDetail : Codable {
    let rocketId: String
    let rocketName: String?
    let wikipedia: String?
}

struct Rocket : Codable {
    let rocketId: String
}

struct LaunchDetail : Codable {
    let flightNumber: Int
    let missionName: String?
    let launchSuccess: Bool?
    var launchDateUnix: Double?
    var details: String?
    let rocket: Rocket?
}
