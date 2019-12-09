//
//  RocketViewController.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 7/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RocketViewController : UIViewController, UITextViewDelegate {
    @IBOutlet weak var textOutput: UITextView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel = RocketViewModel()
    
    var flightNumber = 0
    
    var indicator = NetworkIndicatorView()
    
    var attributedString = ""
    
    override func viewDidLoad() {
        if let launch = viewModel.fetchLaunch(flightNumber: flightNumber) {
            launch.subscribe({ [weak self] data in
                guard let self = self else { return }
                if let launchdetail = data.element {
                    self.recieveLaunchDetails(data: launchdetail)
                } else if data.error != nil {
                    self.textOutput.isHidden = true
                    self.indicator.error()
                }
            }).disposed(by: disposeBag)
        }
        indicator = NetworkIndicatorView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        indicator.center = self.view.center
        view.addSubview(indicator)
        indicator.bottomLabel.text = ""
        indicator.start()
    }
    
    func recieveLaunchDetails(data: LaunchDetail) {
        attributedString += String(format:
            "Flight Number: %d\n\nMission Name: %@\n\nLaunch Time: %@\n\nDetails: %@\n\n", data.flightNumber ?? 0, (data.missionName ?? "???") , Date(timeIntervalSince1970: data.launchDateUnix ?? 0).description, (data.details ?? "???"))
        if let rocketId = data.rocket?.rocketId {
            if let rocket = viewModel.fetchRocket(rocketId: rocketId) {
                rocket.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let rocketdetail = data.element {
                        self.recieveRocketDetails(data: rocketdetail)
                    } else if data.error != nil {
                        self.textOutput.isHidden = true
                        self.indicator.error()
                    }
                    }).disposed(by: disposeBag)
            }
        }
    }
    
    func recieveRocketDetails(data: RocketDetail) {
        attributedString += String(format:
            "Rocket Name: %@\n\n", (data.rocketName ?? "???"))
        var attrib = NSMutableAttributedString(string: attributedString)
        if let linkUrl = data.rocketName {
            attributedString += "Wikipedia: "
            let start = attributedString.count
            attributedString += linkUrl
            attrib = NSMutableAttributedString(string: attributedString)
            attrib.addAttribute(.link, value: linkUrl, range: NSRange(location: start,length: linkUrl.count))
        }
        attrib.addAttribute(.font, value: textOutput.font!, range: NSRange(location: 0,length: attributedString.count))
    
        textOutput.attributedText = attrib
        self.indicator.stop()
        self.textOutput.isHidden = false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
