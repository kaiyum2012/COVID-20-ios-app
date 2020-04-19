//
//  CheckBox.swift
//  COVID2020
//
//  Created by Student on 2020-04-19.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

// REFERENCE : https://stackoverflow.com/questions/29117759/how-to-create-radio-buttons-and-checkbox-in-swift-ios
import UIKit

//class CheckBox: UIButton {
//    // Images
//    let checkedImage = UIImage(named: "checkbox-checked")! as UIImage
//    let uncheckedImage = UIImage(named: "checkbox-unchecked")! as UIImage
//
//    // Bool property
//    var isChecked: Bool = false {
//        didSet {
//            if isChecked == true {
//                self.setImage(checkedImage, for: UIControl.State.normal)
//            } else {
//                self.setImage(uncheckedImage, for: UIControl.State.normal)
//            }
//        }
//    }
//
//    override func awakeFromNib() {
//        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
//        self.isChecked = false
//    }
//
//    @objc func buttonClicked(sender: UIButton) {
//        if sender == self {
//            isChecked = !isChecked
//        }
//    }
//}
