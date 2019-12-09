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
    
    var indicator = NetworkIndicatorView()
    
    var error : Error? = nil
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(reconnect(_:)),
                                  for: .valueChanged)
        
        // called if there is a network error
        viewModel.errors.subscribe({ data in
            if let err = data.element {
                self.error = err
                self.indicator.error()
                self.refreshControl?.endRefreshing()
            }
        }).disposed(by: disposeBag)
        
        // make initial network call
        reconnect(self)
        
        let dataSource = RxTableViewSectionedReloadDataSource<LaunchSection>(
          configureCell: { dataSource, tableView, indexPath, data in
            let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as! LaunchTableViewCell
            cell.launch = data
            return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].header
        }
        
        let sections = viewModel.launches.map ({ [weak self] launch -> [LaunchSection] in
            guard let self = self else { return [] }
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
            self.refreshControl?.endRefreshing()
            if self.error == nil {
                self.indicator.stop()
            }
            return sections.sorted { left, right in
                left.header < right.header
            }
        })
        sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        indicator = NetworkIndicatorView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        tableView.backgroundView = indicator
        indicator.attach(view: tableView)
        indicator.start()
    }

    @objc func reconnect ( _ sender : Any) {
        error = nil
        viewModel.reconnect()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let options = segue.destination as? OptionsViewController {
            options.setup(sort: viewModel.sort, filter: viewModel.filter)
            options.viewModel.filter.subscribe({ [weak self] event in
                guard let self = self else { return }
                if let method = event.element {
                    self.viewModel.filter = method
                    self.viewModel.update()
                }
            }).disposed(by: disposeBag)
            
            options.viewModel.sort.subscribe({ [weak self] event in
                guard let self = self else { return }
                if let method = event.element {
                    self.viewModel.sort = method
                    self.viewModel.update()
                }
            }).disposed(by: disposeBag)
        } else if let rocket = segue.destination as? RocketViewController {
            if let cell = sender as? LaunchTableViewCell {
                rocket.flightNumber = cell.launch?.flightNumber ?? 0
            }
        }
    }
}
