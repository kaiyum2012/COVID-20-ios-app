//
//  DecimalNumberFormatter.swift
//  COVID2020
//
//  Created by Student on 2020-04-16.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import Foundation

import Charts

class DecimalNumberFormatter: NSObject,IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return  GetFormatedNumber(for: NSNumber(value: value), displayType: .decimal)
    }
    
    var chart : BarLineChartViewBase?
    
    init(chart : BarLineChartViewBase) {
        self.chart = chart
    }
}
