//
//  NewWordViewController.swift
//  Choices
//
//  Created by Shubhra Mishra on 10/31/20.
//

import UIKit

class NewWordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        imagePickerController.delegate = self
    }
    
    @IBOutlet weak var newWordInput: UITextField!
    
    @IBOutlet weak var addNewWordButton: UIButton!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    var imagePickerController = UIImagePickerController()
    
    weak var delegate: NewWordProtocol?
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true) { }
    }
    
    @IBAction func addWordButtonPressed(_ sender: Any) {
        var word = ""
        if pickedImage.image == nil {
            let alertController = UIAlertController(
                title: "No picture added",
                message: "Please add a picture for your word to proceed.",
                preferredStyle: UIAlertController.Style.alert
            )

            /*let cancelAction = UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.destructive) { (action) in
                // ...
            }*/

            let confirmAction = UIAlertAction(
                title: "OK", style: UIAlertAction.Style.default) { (action) in
                // ...
            }

            alertController.addAction(confirmAction)
            //alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
            return
        }
        if let newWord = newWordInput.text {
            word = newWord
            if let img = pickedImage.image {
                SavedData.userDictionary[word] = img
            }
        }
        self.delegate?.reloadDictionary()
        self.dismiss(animated: true) {}
    }
    
}

extension NewWordViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            pickedImage.image = img
        }
        dismiss(animated: true) {}
    }
}

protocol NewWordProtocol: class {
    func reloadDictionary()
}
