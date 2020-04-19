//
//  AssesmentTableViewCell.swift
//  COVID2020
//
//  Created by Student on 2020-04-19.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import UIKit

class AssesmentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var optionsStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setOptions(options data : SelfAssesment){
      
        for option in data.options {
            
//            let opt = Checkbox()
            let opt = UILabel(frame: CGRect())

            optionsStack.addSubview(opt)

            opt.translatesAutoresizingMaskIntoConstraints = false

            opt.leadingAnchor.constraint(equalTo: self.optionsStack.leadingAnchor).isActive=true
            opt.trailingAnchor.constraint(equalTo: self.optionsStack.trailingAnchor).isActive = true

            opt.leadingAnchor.constraint(lessThanOrEqualTo: self.optionsStack.leadingAnchor).isActive = true
            opt.trailingAnchor.constraint(lessThanOrEqualTo: self.optionsStack.trailingAnchor).isActive = true

            opt.lineBreakMode = .byWordWrapping
            
            
//            opt.autoresizesSubviews = true
//            opt.titleLabel!.text = option
            opt.text = option
            
//            opt.imageView?.leadingAnchor.constraint(equalTo: self.optionsStack.leadingAnchor).isActive = true
//
//            opt.isSelected = false
//
      
            
        }
//
    }

}
