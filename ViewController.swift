//
//  ViewController.swift
//  Choices App
//
//  Created by Shubhra Mishra on 8/4/20.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var filteredData = [String]() //this is what shows up in the tableview under the searchbar
    var searching = false //whether or not there is text in the searchbar
    var userDictionary = [String]() //user dictionary - goes in the collection view (collection view not made yet)
    var completeDictionary = [String]() //complete dictionary with all words
    var leftDictionary = [String]() //edited complete dictionary: when a user adds a word to their dictionary, it is remoced from leftDictionary
    
    //override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Input the data into the array completeDictionary from the csv file
        for n in 1...65 {
            completeDictionary.append(getdata(r: n, c: 0))
            leftDictionary.append(getdata(r: n, c: 0))
        }
        
        //searchbar
        searchbar.delegate = self
        
        //tableview
        displaysearch.delegate = self
        displaysearch.dataSource = self
        hideWordAdding(bool: true)
        
        //user dictionary
        //userdictionary.dataSource = self
    }
    
    
    //getting images from the internet
    func getImage(row:Int, column:Int) -> UIImage{
        let url = URL(string: self.getdata(r:row, c:column))!
        let data1 = try? Data(contentsOf: url)
        let image = UIImage(data:data1!)
        /*notes from meeting: download picture to the device
            check if image exists, if yes, do nothing
            if not, download
         file manager = allows you to access the file system*/
        return image!
    }
    
    //searching words
    @IBOutlet weak var searchbar: UISearchBar!
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchText \(searchText)")
        if searchbar.text == nil || searchbar.text == "" {
                filteredData = leftDictionary
                displaysearch.reloadData()
            }
        else {
            filteredData = leftDictionary.filter{ $0.lowercased().starts(with: searchbar.text!.lowercased()) }
                displaysearch.reloadData()
        }
            searching = true
    }
    func searchBar(_ searchBar: UISearchBar, searchText: String) {
        if searchbar.text == nil || searchbar.text == "" {
                filteredData = leftDictionary
                displaysearch.reloadData()
        }
        else {
            filteredData = leftDictionary.filter{ $0.lowercased().starts(with: searchbar.text!.lowercased()) }
                displaysearch.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print(searchbar.text)
        print(filteredData)
    }
    
    
    //table view stuff
    @IBOutlet weak var displaysearch: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredData.count
         }
         else {
            return leftDictionary.count
         }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
           cell?.textLabel?.text = filteredData[indexPath.row]
        }
        else {
            cell?.textLabel?.text = leftDictionary[indexPath.row]
        }
        return cell!
    }
    
    //tableview - selecting a box
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        if currentCell.textLabel!.text != nil {
            let selectedText = currentCell.textLabel!.text!
            let myRow = leftDictionary.firstIndex(of: selectedText)!+1
            let section = 2
            linkimage.image = getImage(row: myRow, column: section)
            userDictionary.append(currentCell.textLabel!.text!)
            let index = leftDictionary.firstIndex(of: selectedText)!
            leftDictionary.remove(at: index)
            print(leftDictionary)
            print(userDictionary)
            tableView.reloadData()
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
    
    //add button
    @IBOutlet weak var addbutton: UIButton!
    @IBAction func addButtonPressed(_ sender: Any) {
        hideWordAdding(bool: false)
    }
    
    
    //everything related to loading the image into the image view
    @IBOutlet weak var linkimage: UIImageView!

    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }

  
    
    
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

    
    
    
    
    
    
}

