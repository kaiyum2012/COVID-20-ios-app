//
//  PieChartFormatter.swift
//  COVID2020
//
//  Created by Student on 2020-04-22.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import Foundation
import Charts
//reference :: https://stackoverflow.com/questions/47470920/allow-piechartview-to-hide-labels-for-tiny-slices-in-swift

public class PieChartFormatter: NSObject, IValueFormatter{

    var key :  String
    var minDisplayValue : Double
    init(key : String, minValue : Double) {
        self.key = key
        self.minDisplayValue = minValue
    }
    
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {

        let total = UserDefaults.standard.double(forKey: key)

        var valueToUse = value/total * 100
        valueToUse = Double(round(10*valueToUse)/10)
    
        if(valueToUse<minDisplayValue) {
            return ""
        }
        else {
            return String(value)
        }
    }

}   
