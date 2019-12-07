//
//  LaunchTableController.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 5/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class LaunchTableController: UITableViewController {
    
    var viewModel : LaunchViewModel = LaunchViewModel()
    
    private let disposeBag = DisposeBag()
    
    var indicator = UIActivityIndicatorView()
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        let dataSource = RxTableViewSectionedReloadDataSource<LaunchSection>(
          configureCell: { dataSource, tableView, indexPath, data in
            let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as! LaunchTableViewCell
            cell.launch = data
            return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].header
        }
        
        
        let sections = viewModel.launches.map ({ launch -> [LaunchSection] in
            var sections: [LaunchSection] = []
            var map = Dictionary<String,[Launch]>()
            switch self.viewModel.sort {
            case .alphabetical:
                launch.forEach({ target in
                    if let name = target.missionName {
                        if map[name[name.startIndex].uppercased()] == nil {
                            map[name[name.startIndex].uppercased()] = []
                        }
                        map[name[name.startIndex].uppercased()]?.append(target)
                    }
                })
            case .year:
                launch.forEach({ target in
                    if let name = target.launchYear {
                        if map[name] == nil {
                            map[name] = []
                        }
                        map[name]?.append(target)
                    }
                })
            default :
                map["Mission Number"] = launch
            }
            map.forEach({ section in
                sections.append(LaunchSection(header: section.key, items: section.value))
            })
            self.indicator.hidesWhenStopped = true
            self.indicator.stopAnimating()
            return sections.sorted { left, right in
                left.header < right.header
            }
        })
        sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        indicator = UIActivityIndicatorView(frame: CGRect(x:0,y: 0,width: 40,height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let options = segue.destination as? OptionsViewController {
            options.setup(sort: viewModel.sort, filter: viewModel.filter)
            options.viewModel.filter.subscribe({ [weak self] event in
                if let method = event.element {
                    self?.viewModel.filter = method
                    self?.viewModel.update()
                }
            }).disposed(by: disposeBag)
            
            options.viewModel.sort.subscribe({ [weak self] event in
                if let method = event.element {
                    self?.viewModel.sort = method
                    self?.viewModel.update()
                }
            }).disposed(by: disposeBag)
        } else if let rocket = segue.destination as? RocketViewController {
            if let cell = sender as? LaunchTableViewCell {
                rocket.flightNumber = cell.launch?.flightNum ?? 0
            }
        }
    }
}
