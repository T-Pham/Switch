//
//  ViewController.swift
//  SwitchDemo
//
//  Created by Thanh Pham on 8/31/16.
//  Copyright © 2016 TPM. All rights reserved.
//

import UIKit
import RoundedSwitch

class ViewController: UIViewController {

    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var sectionHeaderLabel: UILabel!
    var mySwitch: Switch!

    override func viewDidLoad() {
        super.viewDidLoad()
        mySwitch = Switch()
        mySwitch.leftText = "Windows"
        mySwitch.rightText = "Mac"
        mySwitch.rightSelected = true
        mySwitch.tintColor = UIColor.purpleColor()
        mySwitch.disabledColor = mySwitch.tintColor.colorWithAlphaComponent(0.2)
        mySwitch.sizeToFit()
        mySwitch.addTarget(self, action: #selector(ViewController.switchDidChangeValue(_:)), forControlEvents: .ValueChanged)
        view.addSubview(mySwitch)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mySwitch.frame = CGRectApplyAffineTransform(sectionHeaderLabel.frame, CGAffineTransformMakeTranslation(0, sectionHeaderLabel.frame.size.height + 15))
    }

    @IBAction func switchDidChangeValue(theSwitch: Switch) {
        statusLabel.text = "\"\(theSwitch.rightSelected ? theSwitch.rightText ?? "" : theSwitch.leftText ?? "")\" selected"
    }
}
