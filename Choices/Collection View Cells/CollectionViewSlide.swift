//
//  CollectionViewSlide.swift
//  Choices
//
//  Created by Shubhra Mishra on 8/16/20.
//

import UIKit

class CollectionViewSlide: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slideSearchBar.delegate = self
        slideDisplaySearch.delegate = self
        slideDisplaySearch.dataSource = self
        slideDisplaySearch.register(UITableViewCell.self, forCellReuseIdentifier: "tblcell")
        
    }
    
    public func configure(image: UIImage) {
        slideImage.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewSlide", bundle: nil)
    }
    
    static let identifier = "CollectionViewSlide"
    
    @IBOutlet weak var slideLabel: UILabel!
    
    @IBOutlet weak var slideImage: UIImageView!
    
    @IBOutlet weak var slideSearchBar: UISearchBar!
    
    @IBOutlet weak var slideDisplaySearch: UITableView!
    
    @IBOutlet weak var slideAddButton: UIButton!
    
    var userDictionary: [String:UIImage] = SavedData.userDictionary
    
    var filteredData = Array(SavedData.userDictionary.keys) //what shows up when the user searches
    
    var leftDictionary = Array(SavedData.userDictionary.keys) //words that haven't already been chosen as an option. if "apple" is the first option, leftDictionary = userDictionary - apple. not implemented yet.
}

extension CollectionViewSlide: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    //searching stuff
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text ?? ""
        filteredData = leftDictionary.filter{ $0.lowercased().starts(with: searchText.lowercased()) }
        filteredData.sort()
        slideDisplaySearch.reloadData()
        
    }
    
    //viewing searches
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return Array(userDictionary.keys).count
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblcell")
        filteredData.sort()
        cell?.textLabel?.text = filteredData[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        slideLabel.isHidden = false
        slideImage.isHidden = false
        slideSearchBar.isHidden = true
        slideDisplaySearch.isHidden = true
        slideLabel.text = currentCell.textLabel?.text
        slideImage.image = userDictionary[(currentCell.textLabel?.text)!]
        if let word = currentCell.textLabel?.text {
            if optionsList.options.count == 0 {
                optionsList.add(word: word)
            } else {
                optionsList.add(word:word)
            }
        }
        print(optionsList.options)
    }
    
    //pressing the add slide button
    @IBAction func pressAddSlide(_ sender: Any) {
        slideAddButton.isHidden = true
        slideSearchBar.isHidden = false
        slideDisplaySearch.isHidden = false
        //SlideViewController().reloadCV()
    }
}
