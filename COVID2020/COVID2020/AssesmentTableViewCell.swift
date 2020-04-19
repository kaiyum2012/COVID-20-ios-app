//
//  AssesmentTableViewCell.swift
//  COVID2020
//
//  Created by Student on 2020-04-19.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import UIKit

class AssesmentTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var optionsStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setQuestionLabel(_ value : String){
        questionLabel.text = value;
    }
    
    public func setOptions(options data : SelfAssesment){
      
        for option in data.options {
            
            let optionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            optionLabel.text = option
            optionLabel.textAlignment = .left
            optionsStack.addSubview(optionLabel)
            
        }
//        TODO:: ADD to support Check box and radio
        //        let o = CheckBox(type: .system)
//        o.titleLabel!.text = data.options[0]
//       optionsStack.addSubview(o)
//       optionsStack.reloadInputViews()
        
        

//        switch data.type {
//        case OptionType.MULTIPLE:
//            for option in data.options {
//                let o = CheckBox(type: .system)
//                o.titleLabel!.text = option
//                optionsStack.addSubview(o)
//                optionsStack.reloadInputViews()
//            }
//            break
//        default:
//            print("no option type")
//            for option in data.options {
//                let o = CheckBox(type: .system)
//                o.titleLabel!.text = option
//                optionsStack.addSubview(o)
//            }
//        }
        
        
        
    }

}
