//
//  FlightViewModel.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 5/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay


class LaunchViewModel {
    var launches : Observable<[Launch]> {
        return mLaunches.asObservable().map { [weak self] arr in
            guard let this = self else { return [] }
            return this.filter(array:
                this.sort(array: arr, method: this.sort),
                               method: this.filter)
        }
    }
    private let mLaunches = BehaviorSubject<[Launch]>(value: [])
    let disposeBag = DisposeBag()

    var filter : Options.FilterMethod = .none
    var sort : Options.SortMethod = .none
    
    init() {
        DataStore.instance.fetchLaunches()?.subscribe({ [weak self] data in
            guard let this = self else { return }
            if let value = data.element {
                this.mLaunches.onNext(value)
            }
        }).disposed(by: disposeBag)
    }
    
    func sort(array: [Launch], method: Options.SortMethod) -> [Launch] {
        switch method {
        case Options.SortMethod.alphabetical:
            return array.sorted(by:
            { $0.missionName ?? "0" < $1.missionName ?? "0" })
        case Options.SortMethod.year:
            return array.sorted(by:
            { $0.launchYear ?? "0" < $1.launchYear ?? "0" })
        default:
            return array.sorted(by:
            { $0.flightNum ?? 0 < $1.flightNum ?? 0 })
        }
    }
    
    func filter(array: [Launch], method: Options.FilterMethod) -> [Launch] {
        var out = array
        switch method {
        case Options.FilterMethod.success:
            out.removeAll { $0.launchSuccess == nil || $0.launchSuccess == false }
        case Options.FilterMethod.failure:
            out.removeAll { $0.launchSuccess == nil || $0.launchSuccess == true }
        default: break
        }
        return out
    }
    
    func update() {
        try! mLaunches.onNext(mLaunches.value())
    }
    
    func numberOfSections() -> Int {
        
        switch sort {
        case .alphabetical:
            return 26
        case .year:
            var x : [Launch] = []
            try! x = mLaunches.value().reduce(into: [], { result, launch in
                if result.firstIndex(where: { x in
                    x.launchYear == launch.launchYear
                }) != -1 {
                    result + [launch]
                }
                })
            return x.count
        default:
            return 0
        }
    }
    
    func titleForHeaderInSection(_ section: Int ) ->String {
        return "boo"
    }

}
