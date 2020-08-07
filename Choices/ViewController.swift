//
//  ViewController.swift
//  Choices App
//
//  Created by Shubhra Mishra on 8/4/20.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    //image picker
    
    
    //table view stuff
    @IBOutlet weak var displaysearch: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycell = UITableViewCell()
        mycell.textLabel?.text = "search"
        return mycell
        
    }
    
    /*func updateTableView(_ tableView:UIView, cellForRowAt indexPath: IndexPath) {
        let mycell = UITableViewCell()
        mycell.textLabel?.text = arr[indexPath.row]
    }*/

    func getFilteredData () -> [String] {
        var filteredData: [String] = []
        filteredData  = pickerData.filter { $0.contains(searchbar.text!)}
        return filteredData
    }
    
    //testbutton
    @IBOutlet weak var testbutton: UIButton!
    @IBAction func testbuttonclicked(_ sender: Any) {
        print(searchBarSearchButtonClicked(searchbar))
        var filteredData: [String] = []
        filteredData  = pickerData.filter { $0.contains(searchbar.text!)}
        let ind = IndexPath(row: 0, section: 0)
        //self.updateTableView(displaysearch, cellForRowAt: ind)
        print(filteredData)
    }
    
    
    
    
    //searching images
    @IBOutlet weak var searchbar: UISearchBar!
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchText \(searchText)")
    }
    
    
    private func searchBarSearchButtonClicked(_ searchBar: UISearchBar) -> String{
        let str = searchBar.text!
        return str
    }
    
    
    //everything related to loading the image into the image view
    @IBOutlet weak var linkimage: UIImageView!
    
    //everything related to the word picker
    @IBOutlet weak var wordpicker: UIPickerView!
    var pickerData: [String] = [String]()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerData[row]
    }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }

  
    //everything related to picking something in the picker
    @IBOutlet weak var donebutton: UIButton!
    @IBAction func doneclicked(_ sender: Any) {

        let index = wordpicker.selectedRow(inComponent: 0)
        let row = index+1
        let column = 2
        let url = URL(string: self.getdata(r:row, c:column))
            let data1 = try? Data(contentsOf: url!) //gets image from url
            linkimage.image = UIImage(data: data1!) //uploads image to the imageViewer
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

        
    //override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // connecting data to the wordpicker
        self.wordpicker.delegate = self
        self.wordpicker.dataSource = self
        // Input the data into the array
        for n in 1...65 {
            pickerData.append(getdata(r: n, c:0))
        }
        //searchbar
        searchbar.delegate = self
        
        //tableview
        displaysearch.delegate = self
        displaysearch.dataSource = self
    }
    
    
}

