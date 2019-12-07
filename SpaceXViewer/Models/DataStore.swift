//
//  DataStore.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 5/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import RxSwift


class DataStore {
    static let instance = DataStore()
    private init () {
    
    }
    
    // cache the data so we don't need to GET all the time.
    func fetchLaunches() -> Observable<[Launch]>?
    {
        guard let url = URL(string: "https://api.spacexdata.com/v3/launches?filter=flight_number,mission_name,launch_success,launch_year") else { return nil }
        return NetworkApi.GET(url: url)
    }
    
    func fetchLaunch(flightNumber: Int) -> Observable<LaunchDetail>?
    {
        guard let url = URL(string: "https://api.spacexdata.com/v3/launches/" + String(flightNumber) + "?filter=flight_number,mission_name,launch_success,details,rocket/rocket_id,launch_date_unix") else { return nil }
        return NetworkApi.GET(url: url)
    }
    
    func fetchRocket(rocketId: String) -> Observable<RocketDetail>?
    {
        guard let url = URL(string: "https://api.spacexdata.com/v3/rockets/" + rocketId + "?filter=rocket_id,rocket_name,wikipedia") else { return nil }
        return NetworkApi.GET(url: url)
    }
}
