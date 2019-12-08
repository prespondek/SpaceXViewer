//
//  NetworkIndicationNib.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 8/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class NetworkIndicatorView : UIView {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var contentView:UIView?
    
    func start() {
        spinner.startAnimating()
        bottomLabel.isHidden = true
        topLabel.isHidden = true
    }
    
    func stop() {
        isHidden = true
        spinner.stopAnimating()
        bottomLabel.isHidden = true
        topLabel.isHidden = true
    }
    
    func error() {
        spinner.stopAnimating()
        bottomLabel.isHidden = false
        topLabel.isHidden = false
    }
    
    func attach(view: UIView) {
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy:
            NSLayoutConstraint.Relation.equal, toItem: view, attribute:
            NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let tailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)

        view.addConstraints([topConstraint,bottomConstraint,tailingConstraint,leadingConstraint])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        
    }
    
    func setup() {
        loadNib()
    }
    
    deinit { }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NetworkIndicator", bundle: bundle)
        let view = nib.instantiate(
            withOwner: self,
            options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
}
