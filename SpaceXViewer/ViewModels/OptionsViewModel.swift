//
//  OptionsViewModel.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 7/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class OptionsViewModel {
    var headers = ["Sort By","Launch Filter"]
    var labels = [["Alphabetical","Year"],
                 ["Success","Failure"]]
    
    var filter = BehaviorRelay<Options.FilterMethod>(value: .none)
    var sort = BehaviorRelay<Options.SortMethod>(value: .none)
    
    func isSwitchOn(indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            if indexPath.row == 0 && sort.value == .alphabetical { return true }
            if indexPath.row == 1 && sort.value == .year { return true }
        } else {
            if indexPath.row == 0 && filter.value == .success { return true }
            if indexPath.row == 1 && filter.value == .failure { return true }
        }
        return false
    }
    
    func switchChanged(indexPath: IndexPath, state: Bool) {
        switch indexPath.section {
        case 0:
            if (state == false) {
                sort.accept(.none)
            } else {
                sortChanged(state: indexPath.row)
            }
        case 1:
            if (state == false) {
                filter.accept(.none)
            } else {
                filterChanged(state: indexPath.row)
            }
        default:
            assertionFailure("state not supported")
            return
        }
    }
    
    func filterChanged(state: Int) {
        switch state {
        case 0: filter.accept(.success)
        case 1: filter.accept(.failure)
        default:
            assertionFailure("state not supported")
            return
        }
    }
    
    func sortChanged(state: Int) {
        switch state {
        case 0: sort.accept(.alphabetical)
        case 1: sort.accept(.year)
        default:
            assertionFailure("state not supported")
            return
        }
    }
}
