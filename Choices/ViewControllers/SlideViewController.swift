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
        slideCollectionView.dragDelegate = self
        //slideCollectionView.dropDelegate = self - uncommenting this line crashes the app when a cell is dropped somewhere
        slideCollectionView.register(CollectionViewSlide.nib(), forCellWithReuseIdentifier: CollectionViewSlide.identifier)
        closeButton.isHidden = true
        self.navigationItem.hidesBackButton = true
        
    }
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var yesNoButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var slideCollectionView: UICollectionView!

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
        slideCollectionView.reloadData()
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        optionsList.currentPos += 1
        //if the user already has something saved for currentpos
        if(optionsList.currentPos < optionsList.listOfSlides.count) {
            if let arr = optionsList.listOfSlides[optionsList.currentPos] {
                optionsList.list = arr
                if arr == [""] {
                    optionsList.list = nil
                    optionsList.reset()
                }
                slideCollectionView.reloadData()
            }
        }
        //makes a blank slide
        else if optionsList.currentPos == optionsList.listOfSlides.count {
            optionsList.list = nil
            optionsList.reset()
            slideCollectionView.reloadData()
            optionsList.reset()
        }
        //makes a blank slide - essentially the same as the previous one, but i had to make these two different to avoid an error
        else {
            let arr = optionsList.options
            let total = optionsList.listOfSlides.count
            optionsList.listOfSlides[total] = arr
            slideCollectionView.reloadData()
            optionsList.reset()
        }
     }
    
    @IBAction func previousButtonClicked(_ sender: Any) {
        optionsList.listOfSlides[optionsList.currentPos] = optionsList.options
        optionsList.currentPos -= 1
        let total = optionsList.currentPos
        optionsList.options.removeAll()
        let los = optionsList.listOfSlides[total]
        if let listOfSlides = los {
            optionsList.options = listOfSlides
            optionsList.list = listOfSlides
        }
        slideCollectionView.reloadData()
    }
    
   @IBAction func dictionaryButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}




extension SlideViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsList.options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewSlide
        //changing identifier to CollectionViewSlide.identifier connects to the xib file
        cell.delegate = self
        cell.delegate1 = self
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.slideDisplaySearch.reloadData()
        
        if optionsList.currentPos == 0 {
            previousButton.isHidden = true
        }
        else {
            previousButton.isHidden = false
        }
        
        if optionsList.list == nil {
            cell.slideLabel.isHidden = true
            cell.slideImage.isHidden = true
            cell.slideSearchBar.isHidden = true
            cell.slideDisplaySearch.isHidden = true
            cell.slideAddButton.isHidden = false
            cell.slideCloseButton.isHidden = true
            cell.slideSegmentedControl.isHidden = true
            return cell
        }
        
        else {
            cell.slideLabel.isHidden = false
            cell.slideSegmentedControl.isHidden = false //commenting this line out might also help figure the error out
            cell.slideLabel.text = optionsList.list?[indexPath.item]
            cell.slideImage.isHidden = false
            if let w = optionsList.list?[indexPath.item] {
                cell.slideImage.image = SavedData.getImage(word: w)
            }
            cell.slideSearchBar.isHidden = true
            cell.slideDisplaySearch.isHidden = true
            cell.slideAddButton.isHidden = true
            if saveButton.isHidden == true {
                cell.slideCloseButton.isHidden = true
            } else {
                cell.slideCloseButton.isHidden = false
            }
            if cell.slideLabel.text == "" {
                cell.slideAddButton.isHidden = false
                cell.slideCloseButton.isHidden = true
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if saveButton.isHidden == true {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   
}

extension SlideViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        slideCollectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    //functions to allow drag and dorp - drag works, but
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = optionsList.options[indexPath.row]
        let itemProvider = NSItemProvider(object: item as! NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
            
                optionsList.options.remove(at: sourceIndexPath.item)
                optionsList.options.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
                                                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
}


extension SlideViewController: UICollectionViewDropDelegate {
    
    public static func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
            dropSessionDidUpdate session: UIDropSession,
            withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .cancel)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = slideCollectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: slideCollectionView)
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

struct optionsList {
    static var options:[String] = [""] //temporary data structure containing the current 2/3 words
    
    static var listOfSlides:[Int: [String]] = [:] //contains a list of all slides that have been made
    
    static var list:[String]? //same thing as options, but i had to make another list to go over an error
    
    static var currentPos:Int = 0 //keeps track of the current position
    
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
    
}

extension SlideViewController: CollectionViewSlideProtocol {
    func btnAddClicked(from cell:CollectionViewSlide) {
        if slideCollectionView.numberOfItems(inSection: 0) != 3 {
            optionsList.add(word: "")
            let ind = IndexPath(item:optionsList.options.count-1, section: 0)
            self.slideCollectionView.insertItems(at: [ind])
        }
        cell.slideCloseButton.isHidden = true
    }
}
