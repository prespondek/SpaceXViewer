//
//  RocketViewModel.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 7/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import RxSwift

class RocketViewModel {

    func fetchLaunch(flightNumber: Int) -> Observable<LaunchDetail>? {
        return DataStore.instance.fetchLaunch(flightNumber: flightNumber)
    }
    
    func fetchRocket(rocketId: String) -> Observable<RocketDetail>? {
        return DataStore.instance.fetchRocket(rocketId: rocketId)
    }
    
    init() {
    }
}
