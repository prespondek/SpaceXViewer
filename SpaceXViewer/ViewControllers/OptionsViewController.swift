//
//  OptionsViewController.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 6/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class OptionsViewController : UITableViewController {
    
    var viewModel = OptionsViewModel()

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.headers.count
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return viewModel.labels[section].count
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return viewModel.headers[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OptionsTableViewCell
        cell.optionSwitch.setOn(!cell.optionSwitch.isOn, animated: true)
        cell.tapAction?(cell)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsCell", for: indexPath) as! OptionsTableViewCell
        
        cell.optionName.text = viewModel.labels[indexPath.section][indexPath.item]
        cell.optionSwitch.isOn = viewModel.isSwitchOn(indexPath: indexPath)
        
        cell.tapAction = { cell in
            
            self.viewModel.switchChanged(indexPath: indexPath, state: cell.optionSwitch.isOn)
            
            for idx in 0..<tableView.numberOfRows(inSection: indexPath.section) {
                if (idx == indexPath.row) { continue }
                
                guard let other = tableView.cellForRow(at: IndexPath(row: idx, section: indexPath.section)) as? OptionsTableViewCell else { continue }
                    other.optionSwitch.setOn(false, animated: true)
            }
        }
        return cell
    }
    
    func setup(sort: Options.SortMethod, filter: Options.FilterMethod) {
        viewModel.sort.accept(sort)
        viewModel.filter.accept(filter)
        tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
