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
        
    }
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var yesNoButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var slideCollectionView: UICollectionView!
    
    
    

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

}

struct optionsList {
    static var options:[String] = []
    
    static func add(word: String) {
        options.append(word)
    }
    
    static func add(word: String, at: Int) {
        options[at] = word
    }
    
    static func remove(at: Int) {
        options.remove(at: at)
    }
}


extension SlideViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 3
        return optionsList.options.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewSlide
        cell.delegate = self
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.slideLabel.isHidden = true
        cell.slideImage.isHidden = true
        cell.slideSearchBar.isHidden = true
        cell.slideDisplaySearch.isHidden = true
        cell.slideCloseButton.isHidden = true
        return cell
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
        print(optionsList.options)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        closeButton.isHidden = false
        yesNoButton.isHidden = true
        saveButton.isHidden = true
        
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        closeButton.isHidden = true
        saveButton.isHidden = false
        yesNoButton.isHidden = false

    }
}

extension SlideViewController: CollectionViewSlideProtocol {
    func btnAddClicked(from cell:CollectionViewSlide) {
        if optionsList.options.count != slideCollectionView.numberOfItems(inSection: 0) {
            optionsList.add(word: "")
        }
        if slideCollectionView.numberOfItems(inSection: 0) != 3 {
            let ind = IndexPath(item:optionsList.options.count, section: 0)
            self.slideCollectionView.insertItems(at: [ind])
        }
    }
}
