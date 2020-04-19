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

    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.load(URLRequest(url: URL(string: "https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public")!))
    }

}
