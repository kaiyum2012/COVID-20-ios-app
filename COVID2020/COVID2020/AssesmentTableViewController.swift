//
//  AssesmentTableViewController.swift
//  COVID2020
//
//  Created by Student on 2020-04-19.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import UIKit

class AssesmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return assesments.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return assesments[section].options.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "(\(assesments[section].queNO))   \(assesments[section].question)"
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 10
        
        label.backgroundColor = .systemIndigo
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AssesmentTableViewCell

        let optionsStack = cell.optionsStack!
        
        let opt = optionsStack.viewWithTag(100) as! UILabel
        
        optionsStack.addSubview(opt)

        opt.leadingAnchor.constraint(equalTo: optionsStack.leadingAnchor).isActive=true
        opt.trailingAnchor.constraint(equalTo: optionsStack.trailingAnchor).isActive = true
        opt.lineBreakMode = .byWordWrapping

        opt.text = assesments[indexPath.section].options[indexPath.row]
        
        return cell
    }
}
