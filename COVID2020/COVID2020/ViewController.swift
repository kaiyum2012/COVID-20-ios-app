//
//  ViewController.swift
//  COVID2020
//
//  Created by Student on 2020-04-15.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var currentLocation : CLLocationCoordinate2D!
      
    var apiBaseURL = "https://www.bing.com/covid/"
    var extraParam = ""

    let PERC_UNIT = "%"
    
    enum EndPoints : String {
      case WordData = "data"
    }
    
    var covidWordData : CovidWordData!
    
   
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var totalRecovered: UILabel!
    @IBOutlet weak var totalDeaths: UILabel!
    
    @IBOutlet weak var deathRate: UILabel!
    @IBOutlet weak var recoveryRate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchWorldData()
        
        print(Locale.current)
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
//                                print(readableData.areas[0].areas.count)
                                self.updateGlanceViewLabels()
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
        
        
        setDeathRateLabel(GetFormatedNumber(for: NSNumber.init(value:getDeathRate()), displayType: NumberFormatter.Style.decimal))
        
        setRecoveryRateLabel(GetFormatedNumber(for: NSNumber.init(value:getRecoveryRate()), displayType: NumberFormatter.Style.decimal))
    }
    
    //MARK:- Api URL(s)
    private func getWorldDataURL() -> URL! {
        return URL(string:getApiURL(endpoint: EndPoints.WordData))
    }
    
    private func getApiURL(endpoint : EndPoints) -> String {
        return "\(apiBaseURL)\(endpoint.rawValue)?\(extraParam)"
    }

    
}

