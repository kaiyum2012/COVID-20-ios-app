//
//  ViewController.swift
//  COVID2020
//
//  Created by Student on 2020-04-15.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import UIKit
import CoreLocation
import Charts

class ViewController: UIViewController, ChartViewDelegate{
    
    var currentLocation : CLLocationCoordinate2D!
      
    var apiBaseURL = "https://www.bing.com/covid/"
    var extraParam = ""

    let PERC_UNIT = "%"
    let TOP_5_COUNTRY : Int = 5
    
    enum EndPoints : String {
      case WordData = "data"
    }
    
    var covidWordData : CovidWordData!
    
    var sortedCovidWordDataByCountries : [CovidWordData]!
    
   
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var totalRecovered: UILabel!
    @IBOutlet weak var totalDeaths: UILabel!
    
    @IBOutlet weak var deathRate: UILabel!
    @IBOutlet weak var recoveryRate: UILabel!
    
    @IBOutlet weak var worldDataMap: BarChartView!
    
    @IBOutlet weak var nearCountryDataMap: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchWorldData()
    }

    //MARK:- API CALL
    func fetchWorldData() {
        let urlSession = URLSession(configuration: .default)

        if let url = getWorldDataURL(){
    
            let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                
                if let e = error{
                    print(e.localizedDescription.description)
                }
                
                if let data = data {
                    do{
                        let readableData = try JSONDecoder().decode(CovidWordData.self, from: data)
                        self.covidWordData = readableData
                        DispatchQueue.main.async{
//                        Sort data in desc
                            self.sortedCovidWordDataByCountries = self.covidWordData.areas.sorted()
                            self.updateGlanceViewLabels()
                            self.UpdateWorldChart()
                                
                            }
                    }catch{
                        print("Not able to decode world data: \(error)")
                    }
                  }
                }
            dataTask.resume()
        }
    }

    //MARK:- Private functions
    fileprivate func setTotalCasesLabel(_ value: String) {
        totalCases.text = value
    }
    
    fileprivate func setTotalRecoveredLabel(_ value: String) {
        totalRecovered.text = value
    }
    
    fileprivate func setTotalDeathLabel(_ value: String) {
        totalDeaths.text = value
    }
    
    fileprivate func setDeathRateLabel(_ value: String) {
        deathRate.text = value + PERC_UNIT
    }
    
    fileprivate func setRecoveryRateLabel(_ value: String) {
        recoveryRate.text = value + PERC_UNIT
    }
    
    func getDeathRate() -> Double {
        guard let data = covidWordData else {
                   print("Data not yet fetched or available")
                   return 0
               }
        if let x = data.totalDeaths, let y = data.totalConfirmed{
            
             return Double(x * 100) / Double(y)
        }
       return 0
    }
    
    func getRecoveryRate() -> Double {
           guard let data = covidWordData else {
                      print("Data not yet fetched or available")
                      return 0
                  }
           if let x = data.totalRecovered, let y = data.totalConfirmed{
                return Double(x * 100) / Double(y)
           }
          return 0
       }
    
    fileprivate func updateGlanceViewLabels() {
        guard let data = covidWordData else {
            print("Data not yet fetched or available")
            return
        }
        
        if let value = data.totalConfirmed {
            setTotalCasesLabel(GetFormatedNumber(for: NSNumber.init(value: value), displayType: NumberFormatter.Style.decimal))
        }
        
        if let value = data.totalRecovered {
             setTotalRecoveredLabel(GetFormatedNumber(for: NSNumber.init(value: value), displayType: NumberFormatter.Style.decimal))
        }
        if let value = data.totalDeaths {
             setTotalDeathLabel(GetFormatedNumber(for: NSNumber.init(value: value), displayType: NumberFormatter.Style.decimal))
        }
        
        
        setDeathRateLabel(GetFormatedNumber(for: NSNumber.init(value:getDeathRate()), displayType: NumberFormatter.Style.percent))
        
        setRecoveryRateLabel(GetFormatedNumber(for: NSNumber.init(value:getRecoveryRate()), displayType: NumberFormatter.Style.percent))
    }
//    MARK:- MAP methods
    fileprivate func UpdateWorldChart(){
        guard let data = getTopFiveCountryData() else {
            print("Data not yet fetched or available")
            return
        }
        
        let colors = [
            UIColor.systemYellow,
            UIColor.systemGreen,
            UIColor.systemRed
        ]
        
        let legends = ["Cases" , "Recovered" , "Death"]

        var datasets : [BarChartDataSet] = []
        var countries : [String] = []
     
        for barNo in 0..<TOP_5_COUNTRY{
            let barForTotalCases = BarChartDataEntry(x: Double(barNo),y: Double(data[barNo].totalConfirmed!))
            let barForTotalRecovered = BarChartDataEntry(x: Double(barNo),y:Double(data[barNo].totalRecovered!))
            let barForTotalDeaths = BarChartDataEntry(x: Double(barNo),y:Double(data[barNo].totalDeaths!))
            
            let dataset1 = BarChartDataSet(entries: [barForTotalCases,barForTotalRecovered,barForTotalDeaths])
            countries.append(data[barNo].displayName)
            
            dataset1.valueColors = [UIColor.black]
            dataset1.colors = colors
            datasets.append(dataset1)
            
        }
        
        let chartData = BarChartData(dataSets: datasets)
        worldDataMap.delegate = self
        worldDataMap.drawValueAboveBarEnabled = false
        worldDataMap.drawBarShadowEnabled = false
        worldDataMap.fitBars = true
        
        let xAxis = worldDataMap.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = TOP_5_COUNTRY
        xAxis.granularity = 1
        xAxis.valueFormatter = CountryValueFormatter(chart: worldDataMap, targetCountries: countries)
        xAxis.labelTextColor = UIColor.black
      
        let rightAxis = worldDataMap.rightAxis
        rightAxis.enabled = false
        
        let leftAxis = worldDataMap.leftAxis

        leftAxis.valueFormatter = DecimalNumberFormatter(chart: worldDataMap)
        
        let legend = worldDataMap.legend
        
        var legendsEntries: [LegendEntry] = []
        
        for i in 0..<legends.count {
            legendsEntries.append(LegendEntry(label: legends[i], form: legend.form, formSize: legend.formSize, formLineWidth: legend.formLineWidth, formLineDashPhase: legend.formLineDashPhase, formLineDashLengths: legend.formLineDashLengths, formColor: colors[i]))
        }
        
        legend.setCustom(entries: legendsEntries)
        
        worldDataMap.pinchZoomEnabled = true
        worldDataMap.data = chartData
    }
    
    
    //MARK:- DATAstore Methods
    
    func getTopFiveCountryData() -> [CovidWordData]?{
        var topFiveCountries : [CovidWordData] = []
        
        for i in 0..<5{
            topFiveCountries.append(sortedCovidWordDataByCountries[i])
        }
        return topFiveCountries
    }
    
    
    //MARK:- Api URL(s)
    private func getWorldDataURL() -> URL! {
        return URL(string:getApiURL(endpoint: EndPoints.WordData))
    }
    
    private func getApiURL(endpoint : EndPoints) -> String {
        return "\(apiBaseURL)\(endpoint.rawValue)?\(extraParam)"
    }

    
}

