//
//  CountryValueFormater.swift
//  COVID2020
//
//  Created by Student on 2020-04-16.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import Foundation
import Charts

class CountryValueFormatter: NSObject,IAxisValueFormatter {
    var chart : BarLineChartViewBase?
    var target : [String]?
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        if let country = target {
            return "\(country[Int(value)])"
        }
        
        return ""
        
    }
    
    init(chart : BarLineChartViewBase, targetCountries : [String]){
        self.chart = chart
        self.target = targetCountries
        
    }
}
