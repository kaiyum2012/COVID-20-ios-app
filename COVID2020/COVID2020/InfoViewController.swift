//
//  InfoViewController.swift
//  COVID2020
//
//  Created by Student on 2020-04-19.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {

    let infoUrl : String = "https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public"
    
    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfoWebPage()
    }
    
    private func  loadInfoWebPage(){
        guard let url = URL(string: infoUrl) else{
            print("unable to create url")
            return
        }
        webView.load(URLRequest(url: url))
    }

}
