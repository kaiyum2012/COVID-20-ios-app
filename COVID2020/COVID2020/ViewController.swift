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

class ViewController: UIViewController, ChartViewDelegate,CLLocationManagerDelegate{

    var apiBaseURL = "https://www.bing.com/covid/"
    var extraParam = ""

    let PERC_UNIT = "%"
    let TOP_5_COUNTRY : Int = 5
    let PAGE_REFRESH_INTERVAL : Double = 600 // 10 Min
    
    enum EndPoints : String {
      case WordData = "data"
    }
    
    enum NaVIdentifiers : String {
        case ASSESMENT = "assesment"
        case INFO = "info"
    }
    
    var covidWordData : CovidWordData!
    var sortedCovidWordDataByCountries : [CovidWordData]!
    var currentCountryData : CovidWordData!
    var nearestCountrydData : CovidWordData!
    var isSafeAreaCompareNear : Bool = true
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    let geocoder = CLGeocoder()
    var currentCity : String!
    var currentCountry : String!
    
    
    @IBOutlet weak var quickGlanceStack: UIStackView!
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var totalRecovered: UILabel!
    @IBOutlet weak var totalDeaths: UILabel!
    
    @IBOutlet weak var percStack: UIStackView!
    @IBOutlet weak var deathRate: UILabel!
    @IBOutlet weak var recoveryRate: UILabel!
    
    @IBOutlet weak var worldDataMap: BarChartView!
    
    @IBOutlet weak var currentCityView: UIView!
    
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var nearbyCountry: UILabel!
    
    @IBOutlet weak var nearCountryDataMap: PieChartView!
    
    @IBOutlet weak var InfectionBtn: UIButton!
    @IBOutlet weak var assesmentBtn: UIButton!
    
    fileprivate func setupUI() {
        InfectionBtn.layer.cornerRadius = 15
        InfectionBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        InfectionBtn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        InfectionBtn.layer.shadowOpacity = 1.0

        assesmentBtn.layer.cornerRadius = 15
        assesmentBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        assesmentBtn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        assesmentBtn.layer.shadowOpacity = 1.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        DispatchQueue.main.async {
            self.fetchWorldData()
            self.StartGettingLocation()
            
// Reference :: https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
                if self.nearestCountrydData == nil {
                    if let x = self.getNearestCountryData() {
                        self.nearestCountrydData = x
                        print("Nearest Country --> \(x.displayName)")
                        self.SetNearByCountryLabel("\(x.displayName)")
//                         Load Nearest Country Map data
                        self.updateNearestCountryMap()
                    }
                }else{
                    timer.invalidate()
                }
            }
        }
    }

//    MARK:- Location Functions
    fileprivate func StartGettingLocation() {
          locationManager.delegate = self
          //Instruct GPS to start gathering data
          locationManager.startUpdatingLocation()
          //Additionally get permission from user to use GPS
          locationManager.requestWhenInUseAuthorization()
    }
    
    fileprivate func StopGettingLocation() {
           locationManager.stopUpdatingLocation()
    }

    fileprivate func FindCurrentCountry() {
// Reference :: https://stackoverflow.com/questions/44031257/find-city-name-and-country-from-latitude-and-longitude-in-swift
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error == nil, let placemark = placemarks, !placemark.isEmpty {
                if let placemark = placemark.last{
                    if let country = placemark.country{
                        self.currentCountry = country
                        print("Current Country --> \(country)")
                        self.setContaminateIndicator()
                        
                    }
                    
                    if let city = placemark.locality {
                        self.currentCity = city
                        print("Current City --> \(city)")
                        if let country = self.currentCountry{
                            self.SetCurrentCityLabel("\(city), \(country) ")
                        }else{
                            self.SetCurrentCityLabel("\(city)")
                        }
                        
                    }
                }
            }
        }
    }
    
    fileprivate func setContaminateIndicator() {
        guard let nearCountry = nearestCountrydData else {
            print("near country data not available" )
            return
        }
        
        guard let currentCountry = currentCountryData else {
             print("current country data not available" )
            return
            
        }
        
        if let current = currentCountry.totalConfirmed, let near = nearCountry.totalConfirmed{
            if current > near{
                print("'\(currentCountry.displayName)' is  Unsafe country compare to '\(nearCountry.displayName)'")
                isSafeAreaCompareNear = false
                currentCityView.backgroundColor = .systemRed
            }
            else{
                print("'\(currentCountry.displayName)' is safe country compare to '\(nearCountry.displayName)'")
                isSafeAreaCompareNear = true
                currentCityView.backgroundColor = .systemGreen
            }
            
        }
        
    }
    
//    TODO:: WHAT IF PERMISSION DENIED?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l =  locations.last {
            currentLocation =  l
            StopGettingLocation()
            
            FindCurrentCountry()
        }
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
                            self.updateWorldChart()
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
    
    fileprivate func SetNearByCountryLabel(_ value : String){
        nearbyCountry.text?.append(value)
    }
    
    fileprivate func SetCurrentCityLabel(_ value : String){
        currentCityLabel.text = value
        currentCityView.backgroundColor = UIColor.systemGreen
        self.view.bringSubviewToFront(currentCityView)
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
    
    func generateRandomColor() -> UIColor {
      let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
      let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
      let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
            
      return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
//    MARK:- MAP functions
    fileprivate func updateWorldChart(){
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
            dataset1.valueFormatter = DecimalNumberFormatter(chart: worldDataMap)
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
    
    fileprivate func updateNearestCountryMap(){
        guard let data = nearestCountrydData else {
            print("nearest country Data not yet fetched or available")
            return
        }
        
        var pieSlots : [PieChartDataEntry] = []
        
        var states : [String] = []
        var legendColors : [UIColor] = []
     
        let noOfStates = data.areas.count
        var total : Double = 0
        
        for pieNo in 0..<noOfStates{
            
            let x : CovidWordData = data.areas[pieNo]
            
            let pieSlot = PieChartDataEntry(value: Double(x.totalConfirmed!),label: x.displayName)
        
            total += Double(x.totalConfirmed!)
            
            pieSlots.append(pieSlot)
            states.append(x.displayName)
        }
        
        let legend = nearCountryDataMap.legend
        
        var legendsEntries: [LegendEntry] = []
        
        for i in 0..<noOfStates {
            legendColors.append(generateRandomColor())
            legendsEntries.append(LegendEntry(label: states[i], form: legend.form, formSize: legend.formSize, formLineWidth: legend.formLineWidth, formLineDashPhase: legend.formLineDashPhase, formLineDashLengths: legend.formLineDashLengths, formColor: legendColors[i]))
        }
        
        legend.setCustom(entries: legendsEntries)
        
        let dataset = PieChartDataSet(entries: pieSlots)
        dataset.setColors(legendColors, alpha: CGFloat(1.0))
        
        dataset.valueLinePart1OffsetPercentage = 0.1
        dataset.valueLinePart1Length = 0.2
        dataset.valueLinePart2Length = 0.5
        dataset.valueLineVariableLength = true
        dataset.useValueColorForLine = true
        dataset.xValuePosition = .outsideSlice
        dataset.yValuePosition = .outsideSlice
        dataset.automaticallyDisableSliceSpacing = true
        dataset.valueFormatter = DecimalNumberFormatter(chart: nearCountryDataMap)
        
        let chartData = PieChartData(dataSet: dataset)
        chartData.setValueTextColor(.black)
        nearCountryDataMap.delegate = self
        
//        TODO :: Hide Small slices to make clutter free Map 
//        UserDefaults.standard.set(total, forKey: "total")
//        let formatter  = PieChartFormatter(key: "total",minValue: 10)
//        chartData.setValueFormatter(formatter)
        
        nearCountryDataMap.data = chartData
        
        setContaminateIndicator()
    }
    
//    MARK:- Navigation
    @IBAction func selfAssesmentClicked(_ sender: Any) {
        performSegue(withIdentifier: NaVIdentifiers.ASSESMENT.rawValue, sender: self)
    }
    
    @IBAction func InfoClicked(_ sender: Any) {
        performSegue(withIdentifier: NaVIdentifiers.INFO.rawValue, sender: self)
    }
        
    //MARK:- Datastore functions
    
    func getTopFiveCountryData() -> [CovidWordData]?{
        var topFiveCountries : [CovidWordData] = []
        
        for i in 0..<5{
            topFiveCountries.append(sortedCovidWordDataByCountries[i])
        }
        return topFiveCountries
    }
    
    func getNearestStatedata(reference country : CovidWordData) -> CovidWordData? {
            var data : CovidWordData!
            var distance : Double?
                
                guard let location = currentLocation  else {
                    print("Location not detected")
                    return nil
                }
            
                for state in country.areas {
        //            print(country.displayName)
                    if let d = distance {
                        let dis = location.distance(from: CLLocation(latitude: country.lat!, longitude: country.long!))
                        print(" Current: \(d) -----   dis: \(dis) -> state : \(country.displayName)")
        //                print("--> " + data.displayName.lowercased())
                        if(dis < d){
                           data = state
                            distance = dis
        //                    print("dis: \(dis) -> country : \(country.displayName) and current smallest distance \(d) " )
        //                    print("from data   " + data.displayName)
                        }
                    }else{
                        distance = location.distance(from: CLLocation(latitude: country.lat!, longitude: country.long!))
                        print(" Current: \(distance!) -----  state : \(country.displayName) , lat: \(country.lat!) and log: \(country.long!)")
                        data = state
                    }
                }
        return data
    }
    
    
    func getNearestCountryData() -> CovidWordData?{
        var data : CovidWordData!
        var distance : Double?
        
        guard let location = currentLocation else {
            print("Location not detected")
            return nil
        }
        
        guard let countires = covidWordData else {
            print("covid data is not available")
            return nil
        }
    
        for country in countires.areas {
//            print(country.displayName)
            if let d = distance {
                let dis = location.distance(from: CLLocation(latitude: country.lat!, longitude: country.long!))
                print(" Current: \(d) -----   dis: \(dis) -> country : \(country.displayName)")
//                print("--> " + data.displayName.lowercased())
                if(dis < d &&  country.displayName.lowercased() != currentCountry.lowercased()){
                    data = country
                    distance = dis
//                    print("dis: \(dis) -> country : \(country.displayName) and current smallest distance \(d) " )
//                    print("from data   " + data.displayName)
                }else if country.displayName.lowercased() == currentCountry.lowercased() {
                    currentCountryData = country
                }
            }else{
                distance = location.distance(from: CLLocation(latitude: country.lat!, longitude: country.long!))
                print(" Current: \(distance!) -----  country : \(country.displayName) , lat: \(country.lat!) and log: \(country.long!)")
                data = country
            }
        }
        
        return data
    }
    //MARK:- Api URL(s)
    private func getWorldDataURL() -> URL! {
        return URL(string:getApiURL(endpoint: EndPoints.WordData))
    }
    
    private func getApiURL(endpoint : EndPoints) -> String {
        return "\(apiBaseURL)\(endpoint.rawValue)?\(extraParam)"
    }
}

