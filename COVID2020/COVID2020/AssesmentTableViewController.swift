//
//  AssesmentTableViewController.swift
//  COVID2020
//
//  Created by Student on 2020-04-19.
//  Copyright © 2020 Kaiyum. All rights reserved.
//

import UIKit

class AssesmentTableViewController: UITableViewController {

    var optionCount = 0;
    
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for question in assesments {
            optionCount += question.options.count
        }
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
        
        label.backgroundColor = .label
        label.textColor = .white
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AssesmentTableViewCell

        let optionsStack = cell.optionsStack!
        
        let opt = optionsStack.viewWithTag(100) as! UILabel
        
        optionsStack.addSubview(opt)
        
        opt.lineBreakMode = .byWordWrapping

        opt.text = assesments[indexPath.section].options[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    @IBAction func answerClicked(_ sender: UISwitch) {
        
        if sender.isOn{
            optionCount -= 1
            
        }else {
            optionCount += 1
        }
        print(optionCount)
        
        if optionCount == 1
        {
            resultLabel.text = "You should visit nearest Hospital"
            resultLabel.backgroundColor = .systemRed
            resultLabel.textColor = .white
        }
        else {
            resultLabel.text = "No need to worry, Stay home"
            resultLabel.backgroundColor = .systemGreen
            resultLabel.textColor = .white
        }
 
    }
}
