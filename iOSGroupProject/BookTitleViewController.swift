//
//  BookTitleViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-05-16.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit

class BookTitleViewController: UIViewController, UITextFieldDelegate {
    
    var tutorial = false

    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var numberOfPages: UITextField!
    @IBOutlet weak var authorName: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var currentSelectedTextField: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if tutorial == true {
            backButton.isEnabled = false
            backButton.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentSelectedTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentSelectedTextField = nil
        if bookTitle.text != "Book Title" && authorName.text != "Name" && bookTitle.text != "" && authorName.text != "" && numberOfPages.text != ""
    //    if numberOfPages.text == totalPages {
            
      //  }
        {
            continueButton.isEnabled = true
        }
    }
    
    @IBAction func `continue`(_ sender: Any) {
        let thisStoryboard = UIStoryboard(name: "BookSaving", bundle: nil)
        
        let bookSaving = thisStoryboard.instantiateViewController(withIdentifier: "TakePic") as? PictureViewController
        
        bookSaving?.goTutorial = tutorial
        bookSaving?.bookTitle = bookTitle.text!
        bookSaving?.numberOfPages = Int(numberOfPages.text!)!
        bookSaving?.authorsName = authorName.text!
        
        if tutorial == false
        {
            self.revealViewController().setFront(bookSaving, animated: true)
        }
        else
        {
            self.present(bookSaving!, animated: true, completion: nil)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if currentSelectedTextField == authorName
            {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        let thisStoryboard = UIStoryboard(name: "BookScreen", bundle: nil)
        let openedTimerPage = thisStoryboard.instantiateViewController(withIdentifier: "BookSelection") as? BooksViewerController
        self.revealViewController().setFront(openedTimerPage, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
