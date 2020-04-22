//
//  LocaleHelper.swift
//  COVID2020
//
//  Created by Student on 2020-04-15.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import Foundation
import Charts


func GetFormatedNumber(for number : NSNumber, displayType : NumberFormatter.Style ) -> String{
 
    let numberFormater = NumberFormatter()
    numberFormater.usesGroupingSeparator = true
    numberFormater.numberStyle = .decimal
    numberFormater.locale = Locale.current
    
    return numberFormater.string(from: number)!
}

