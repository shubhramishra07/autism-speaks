//
//  SlideViewController.swift
//  Choices
//
//  Created by Shubhra Mishra on 8/17/20.
//

import UIKit

class SlideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideCollectionView.delegate = self
        slideCollectionView.dataSource = self
        slideCollectionView.register(CollectionViewSlide.nib(), forCellWithReuseIdentifier: CollectionViewSlide.identifier)
        
        //let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressGesture(gesture:)))
        //slideCollectionView?.addGestureRecognizer(gesture)
        closeButton.isHidden = true
        self.navigationItem.hidesBackButton = true
        
    }
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var yesNoButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var slideCollectionView: UICollectionView!
    
    var list:[String]?
    
    var currentPos:Int = 0
    

    /*@objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
        guard let cv = slideCollectionView else {  return  }
        switch gesture.state {
        case .began:
            guard let targetIndexPath = cv.indexPathForItem(at: gesture.location(in: cv)) else {
                return
            }
            cv.beginInteractiveMovementForItem(at: targetIndexPath)
            
        case .changed:
            cv.updateInteractiveMovementTargetPosition(gesture.location(in: slideCollectionView))
            
        case .ended:
            cv.endInteractiveMovement()
            
        case .possible:
            cv.updateInteractiveMovementTargetPosition(gesture.location(in: slideCollectionView))
            
        case .cancelled:
            slideCollectionView.cancelInteractiveMovement()
            
        case .failed:
            slideCollectionView.cancelInteractiveMovement()
            
        @unknown default:
            guard let targetIndexPath = cv.indexPathForItem(at: gesture.location(in: cv)) else {
                return
            }
            cv.beginInteractiveMovementForItem(at: targetIndexPath)
        }
    }*/
    @IBAction func saveButtonPressed(_ sender: Any) {
        closeButton.isHidden = false
        yesNoButton.isHidden = true
        saveButton.isHidden = true
        slideCollectionView.reloadData()
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        closeButton.isHidden = true
        saveButton.isHidden = false
        yesNoButton.isHidden = false
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        currentPos += 1
        if(currentPos <= optionsList.listOfSlides.count - 1) {
            if let arr = optionsList.listOfSlides[currentPos] {
                optionsList.options = arr
                print("arr is: \(arr)")
            }
            slideCollectionView.reloadData()
            slideCollectionView.scrollToItem(at: IndexPath(item: currentPos, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        }
        else {
            let arr = optionsList.options
            let total = optionsList.listOfSlides.count
            optionsList.listOfSlides[total] = arr
            optionsList.reset()
            self.list = nil
            slideCollectionView.reloadData()
        }
        print(optionsList.listOfSlides)
        
     }
    
    @IBAction func previousButtonClicked(_ sender: Any) {
        optionsList.listOfSlides[currentPos] = optionsList.options
        currentPos -= 1
        let total = currentPos
        optionsList.options.removeAll()
        let los = optionsList.listOfSlides[total]
        if let listOfSlides = los {
            optionsList.options = listOfSlides
            self.list = listOfSlides
        }
        slideCollectionView.reloadData()
        print(optionsList.listOfSlides)
    }
    
}

struct optionsList {
    static var options:[String] = [""]
    
    static var listOfSlides:[Int: [String]] = [:]
    
    static func add(word: String) {
        options.append(word)
    }
    
    static func insert(word: String, at: Int) {
        options.insert(word, at: at)
    }
    
    static func remove(at: Int) {
        options.remove(at: at)
    }
    
    static func reset() {
        options = [""]
    }
    
    /*static func presentInfo(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewSlide
        cell.slideLabel.text = optionsList.options[indexPath.item]
        if let str = cell.slideLabel.text {
            cell.slideImage.image = SavedData.getImage(word: str)
        }
        return cell
    }*/
}


extension SlideViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*if self.list == nil {
            return optionsList.options.count + 1
        }
        else {
            return optionsList.options.count
        }*/
        return optionsList.options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewSlide
        cell.delegate = self
        cell.delegate1 = self
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        //cell.slideCloseButton.isHidden = self.saveButton.isHidden ? true : false
        cell.slideDisplaySearch.reloadData()
        
        if self.list == nil {
            cell.slideLabel.isHidden = true
            cell.slideImage.isHidden = true
            cell.slideSearchBar.isHidden = true
            cell.slideDisplaySearch.isHidden = true
            cell.slideAddButton.isHidden = false
            cell.slideCloseButton.isHidden = true
            return cell
        }
        
        else {
            cell.slideLabel.isHidden = false
            cell.slideLabel.text = list?[indexPath.item]
            cell.slideImage.isHidden = false
            if let w = list?[indexPath.item] {
                cell.slideImage.image = SavedData.getImage(word: w)
            }
            cell.slideSearchBar.isHidden = true
            cell.slideDisplaySearch.isHidden = true
            cell.slideAddButton.isHidden = true
            cell.slideCloseButton.isHidden = false
            return cell
        }
        //if self.list == nil => hide, else => don't hide
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = optionsList.options.remove(at: sourceIndexPath.item)
        optionsList.options.insert(item, at: destinationIndexPath.item)
    }
    
    
}

extension SlideViewController: CollectionViewSlideProtocol {
    func btnAddClicked(from cell:CollectionViewSlide) {
        
        //!= slideCollectionView.numberOfItems(inSection: 0)
        if slideCollectionView.numberOfItems(inSection: 0) != 3 {
            optionsList.add(word: "")
            let ind = IndexPath(item:optionsList.options.count-1, section: 0)
            self.slideCollectionView.insertItems(at: [ind])
            
        }
    }
}

extension SlideViewController: PositionProtocol {
    var ind: IndexPath {
        get {
            return IndexPath(row: 0, section: 0)
        }
        set {
            
        }
    }
    
    func pos(from cell: CollectionViewSlide) -> IndexPath{
        if let i = self.slideCollectionView.indexPath(for:cell) {
            ind = i
        }
        return ind
    }
    
    func row(from cell: CollectionViewSlide) -> Int{
        var i:Int = 0
        if let r = self.slideCollectionView.indexPath(for: cell)?.row{
            i = Int(r)
        }
        return i
    }
}
