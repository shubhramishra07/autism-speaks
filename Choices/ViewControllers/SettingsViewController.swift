//
//  SettingsViewController.swift
//  Choices
//
//  Created by Shubhra Mishra on 9/5/20.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.navigationItem.hidesBackButton = true
        
    }
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    let settings:[String] = ["landscape", "portrait", "change screen color after the correct answer is picked"]

    @IBAction func dictionaryButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = settings[indexPath.row]
        return cell!
    }
    
    
}
