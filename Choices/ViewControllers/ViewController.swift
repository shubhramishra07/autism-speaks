//
//  ViewController.swift
//  Choices App
//
//  Created by Shubhra Mishra on 8/4/20.
//

import UIKit

class ViewController: UIViewController {
    
    var filteredData = [String]() //this is what shows up in the tableview under the searchbar
    
    var searching = false //whether or not there is text in the searchbar
    
    var completeDictionary = [String]() //complete dictionary with all words. value never changes
    
    var leftDictionary = [String]() //edited complete dictionary: when a user adds a word to their dictionary, it is remoced from leftDictionary
    
    var userArr: [String: UIImage] = [:] //an array that contains the user dictionary
    
    //viewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        // Inputs the data into the array completeDictionary from the csv file
        
        for n in 1...65 {
            completeDictionary.append(getdata(r: n, c: 0))
            leftDictionary.append(getdata(r: n, c: 0))
        }
        
        leftDictionary.sort()
        
        //searchbar
        searchbar.delegate = self
        searchbar1.delegate = self
        
        //tableview
        displaysearch.delegate = self
        displaysearch.dataSource = self
        displaysearch1.delegate = self
        displaysearch1.dataSource = self
        hideWordAdding(bool: true)
        hideWordRemoving(bool: true)
        
        //collectionView
        dictionaryCollectionView.delegate = self
        dictionaryCollectionView.dataSource = self
        dictionaryCollectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }
    
    //search bar on the add side
    @IBOutlet weak var searchbar: UISearchBar!
        
    //table view on the add side
    @IBOutlet weak var displaysearch: UITableView!
    
    //button on the add side
    @IBOutlet weak var addbutton: UIButton!

    //button on the remove side
    @IBOutlet weak var removebutton: UIButton!
    
    //search bar on the remove side
    @IBOutlet weak var searchbar1: UISearchBar!
    
    //table view on the remove side
    @IBOutlet weak var displaysearch1: UITableView!
        
    //collection view on the dictionary page
    @IBOutlet weak var dictionaryCollectionView: UICollectionView!
        
    //button that takes us from the main viewcontroller to the slide page

    @IBOutlet weak var slidesButton: UIBarButtonItem!
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    @IBOutlet weak var removeAllButton: UIButton!
    
    @IBOutlet weak var addAllButton: UIButton!
    
    @IBOutlet weak var addNewWordButton: UIButton!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
  
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

extension ViewController: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == displaysearch { //when we ware viewing the add word table
            if searching {
                filteredData = leftDictionary.filter{ $0.lowercased().starts(with: searchbar.text!.lowercased()) }
                return filteredData.count
             }
             else {
                return leftDictionary.count
             }
        }
        else { //when we are viewing the remove word table
            if searching {
                filteredData = Array(SavedData.userDictionary.keys).filter{ $0.lowercased().starts(with: searchbar1.text!.lowercased()) }
                return filteredData.count
             }
             else {
                return Array(SavedData.userDictionary.keys).count
             }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if tableView == displaysearch { //when we are viewing the add word table
            if searching {
                filteredData.sort()
                if filteredData.indices.contains(indexPath.row) {
                    cell?.textLabel?.text = filteredData[indexPath.row]
                }
            }
            else {
                leftDictionary.sort()
                cell?.textLabel?.text = leftDictionary[indexPath.row]
            }
            return cell!
        }
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1")
        if tableView == displaysearch1 { //when we are viewing the remove word table
            if searching {
                filteredData.sort()
                if filteredData.indices.contains(indexPath.row) {
                    cell?.textLabel?.text = filteredData[indexPath.row]
                }
                return cell1!
            }
            else {
                cell1?.textLabel?.text = SavedData.sorted()[indexPath.row]
                return cell1!
            }
        }
        return cell!
    }
    
    //tableview - selecting a box
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        if tableView == displaysearch {
            if currentCell.textLabel!.text != nil {
                let selectedText = currentCell.textLabel!.text!
                let myRow = completeDictionary.firstIndex(of: selectedText)!+1
                SavedData.userDictionary[selectedText] = getImage(row: myRow)
                let index = leftDictionary.firstIndex(of: selectedText)!
                leftDictionary.remove(at: index)
                tableView.reloadData()
                dictionaryCollectionView.reloadData()
            }
        }
        else {
            let selectedText = currentCell.textLabel!.text!
            let myRow = completeDictionary.firstIndex(of: selectedText)!+1
            SavedData.removeW(word: selectedText)
            leftDictionary.append(currentCell.textLabel!.text!)
            leftDictionary.sort()
            tableView.reloadData()
            dictionaryCollectionView.reloadData()
        }
    }

    func hideWordAdding(bool: Bool) {
        if bool {
            displaysearch.isHidden = true
            searchbar.isHidden = true
        }
        else {
            displaysearch.isHidden = false
            searchbar.isHidden = false
        }
    }
    
    func hideWordRemoving(bool:Bool) {
        if bool {
            displaysearch1.isHidden = true
            searchbar1.isHidden = true
        }
        else {
            displaysearch1.isHidden = false
            searchbar1.isHidden = false
        }
    }
    
    //search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == searchbar {
            if searchBar.text == nil || searchbar.text == "" {
                filteredData = leftDictionary
                filteredData.sort()
                displaysearch.reloadData()
            }
            else {
                filteredData = leftDictionary.filter{ $0.lowercased().starts(with: searchBar.text!.lowercased()) }
                filteredData.sort()
                displaysearch.reloadData()
            }
        }
        else if searchBar == searchbar1 {
            if searchBar.text == nil || searchbar.text == "" {
                filteredData = Array(SavedData.userDictionary.keys)
                filteredData.sort()
                displaysearch1.reloadData()
                }
            else {
                filteredData = Array(SavedData.userDictionary.keys).filter{ $0.lowercased().starts(with:searchBar.text!.lowercased()) }
                filteredData.sort()
                displaysearch1.reloadData()
            }
        }
            searching = true
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        hideWordAdding(bool: false)
        hideWordRemoving(bool: true)
        searching = false
        displaysearch.reloadData()
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        hideWordRemoving(bool: false)
        hideWordAdding(bool: true)
        searching = false
        displaysearch1.reloadData()
    }
    
    /*@IBAction func removeAllButtonPressed(_ sender: Any) {
        SavedData.userDictionary = [:]
        dictionaryCollectionView.reloadData()
    }
    
    @IBAction func addAllButtonPressed(_ sender: Any) {
        for i in completeDictionary {
            SavedData.userDictionary[i] = getImage(row: completeDictionary.firstIndex(of: i)!+1)
        }
        dictionaryCollectionView.reloadData()
    }*/
    
    //adding a new word to the userdictionary
    @IBAction func addNewWordPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "newwordvc") as! NewWordViewController
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Array(SavedData.userDictionary.keys).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        if Array(SavedData.userDictionary.keys) != [] {
            cell.dictionaryLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 15)
            cell.dictionaryLabel.text = SavedData.sorted()[indexPath.item]
            if let str = cell.dictionaryLabel.text {
                cell.dictionaryImage.image = SavedData.userDictionary[str]
            }
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 225, height: 75)
    }
}

extension ViewController {
    //reading the csv file
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: "wordlist", ofType:"csv")
        else {
            return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }

    func cleanRows(file:String) -> String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
                cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
                cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
    
    func getdata(r: Int, c: Int) -> String {
        var data = readDataFromCSV(fileName: "wordlist", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!) //the whole csv file in rows
        let ret = csvRows[r][c]
        return ret
    }
    
    //getting images from the internet
    func getImage(row:Int) -> UIImage{
        let url = URL(string: self.getdata(r:row, c:2))!
        let data1 = try? Data(contentsOf: url)
        let image = UIImage(data:data1!)
        return image!
    }
}

struct SavedData {
    
    static var userDictionary: [String: UIImage] = [:]

    static func getImage(word: String) -> UIImage? {
        return userDictionary[word]
    }

    static func add(word: String, image: UIImage) {
        userDictionary[word] = image
    }
    
    static func removeW(word: String) {
        guard let ind = userDictionary.index(forKey: word) else { return }
        userDictionary.remove(at: ind)
    }
    
    static func sorted() -> [Dictionary<String, UIImage>.Keys.Element] {
        let sorted = Array(userDictionary.keys).sorted(by: <)
        return sorted
    }
}

extension ViewController: NewWordProtocol {
    
    func reloadDictionary() {
        dictionaryCollectionView.reloadData()
    }
    
}
