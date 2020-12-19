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
    
    @IBOutlet weak var slideCloseButton: UIButton!
    
    //@IBOutlet weak var slideSegmentedControl: UISegmentedControl!
    
    var posChange:Int = 0
    
    weak var delegate: CollectionViewSlideProtocol?
    
    weak var delegate1: PositionProtocol?
    
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
        //slideSegmentedControl.isHidden = false
        slideLabel.text = currentCell.textLabel?.text
        slideImage.image = userDictionary[(currentCell.textLabel?.text)!]
        slideCloseButton.isHidden = false
        //PositionProtocol.pos(from: self)
        if let word = currentCell.textLabel?.text {
                //optionsList.add(word: word)
            let r = self.delegate1?.row(from: self)
            if let a = r {
                optionsList.options[a] = word
            }
        }
        optionsList.listOfSlides[optionsList.currentPos] = optionsList.options
    }
    
    //pressing the add slide button
    @IBAction func pressAddSlide(_ sender: Any) {
        slideAddButton.isHidden = true
        slideSearchBar.isHidden = false
        slideDisplaySearch.isHidden = false
        self.delegate?.btnAddClicked(from: self)
    }
    
    /*func hideCross {
        slideCloseButton.isHidden = true
    }
    
    func showCross {
        slideCloseButton.isHidden = false
    }*/
    
    //pressing the cross button
    @IBAction func pressCloseButton(_ sender: Any) {
        slideCloseButton.isHidden = true
        slideSearchBar.isHidden = false
        slideDisplaySearch.isHidden = false
        slideImage.isHidden = true
        slideLabel.isHidden = true
        //slideSegmentedControl.isHidden = true
        if let word = slideLabel.text {
            guard let ind = optionsList.options.firstIndex(of: word) else { return }
            if let r = self.delegate1?.row(from: self) {
                optionsList.options[r] = ""
            }
            posChange = ind
        }
    }
    

}

protocol CollectionViewSlideProtocol: class {
    func btnAddClicked(from cell: CollectionViewSlide)
}

protocol PositionProtocol: class {
    func pos(from cell: CollectionViewSlide) -> IndexPath
    func row(from cell: CollectionViewSlide) -> Int
    var ind: IndexPath{ get set }
}

