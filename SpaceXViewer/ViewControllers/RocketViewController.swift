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
    
    var indicator = UIActivityIndicatorView()
    
    var attributedString = ""
    
    override func viewDidLoad() {
        if let launch = viewModel.fetchLaunch(flightNumber: flightNumber) {
            launch.subscribe({ [weak self] data in
                guard let this = self else { return }
                if let launchdetail = data.element {
                    this.recieveLaunchDetails(data: launchdetail)
                }
            }).disposed(by: disposeBag)
        }
        indicator = UIActivityIndicatorView(frame: CGRect(x:0,y: 0,width: 40,height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func recieveLaunchDetails(data: LaunchDetail) {
        attributedString += String(format:
            "Flight Number: %d\n\nMission Name: %@\n\nLaunch Time: %@\n\nDetails: %@\n\n", data.flightNum ?? 0, (data.missionName ?? "???") , Date(timeIntervalSince1970: data.launchDate ?? 0).description, (data.details ?? "???"))
        if let rocketId = data.rocket?.id {
            if let rocket = viewModel.fetchRocket(rocketId: rocketId) {
                rocket.subscribe({[weak self] data in
                    guard let this = self else { return }
                    if let rocketdetail = data.element {
                        this.recieveRocketDetails(data: rocketdetail)
                        this.indicator.hidesWhenStopped = true
                        this.indicator.stopAnimating()
                    }
                    }).disposed(by: disposeBag)
            }
        }
    }
    
    func recieveRocketDetails(data: RocketDetail) {
        attributedString += String(format:
            "Rocket Name: %@\n\n", (data.name ?? "???"))
        var attrib = NSMutableAttributedString(string: attributedString)
        if let linkUrl = data.link {
            attributedString += "Wikipedia: "
            let start = attributedString.count
            attributedString += linkUrl
            attrib = NSMutableAttributedString(string: attributedString)
            attrib.addAttribute(.link, value: linkUrl, range: NSRange(location: start,length: linkUrl.count))
        }
        attrib.addAttribute(.font, value: textOutput.font!, range: NSRange(location: 0,length: attributedString.count))
    
        textOutput.attributedText = attrib
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
