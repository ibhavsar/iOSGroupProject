//
//  BookTitleViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-05-16.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class BookTitleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var numberOfPages: UITextField!
    @IBOutlet weak var authorName: UITextField!
    
    var book = 0
    
    var currentSelectedTextField: UITextField? = nil
    
    var books: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        getData()
        
        book = books.count
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        save()
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
    }
    
    @IBAction func `continue`(_ sender: Any) {
        let thisStoryboard = UIStoryboard(name: "BookSaving", bundle: nil)
        
        let bookSaving = thisStoryboard.instantiateViewController(withIdentifier: "TakePic")
        
        bookSaving.modalPresentationStyle = .popover
        
        let popoverController = bookSaving.popoverPresentationController
        
        popoverController?.sourceView = self.view as UIView
        
        popoverController?.permittedArrowDirections = .any
        
        present(bookSaving, animated: true, completion: nil)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func save() {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        if book == books.count
        {
            // 2
            let entity =
                NSEntityDescription.entity(forEntityName: "Book", in: managedContext)!
            
            let newBook = NSManagedObject(entity: entity, insertInto: managedContext)
            
            newBook.setValue(bookTitle.text, forKey: "title")
            let pages = Int64(numberOfPages.text!)
            newBook.setValue(pages!, forKey: "pages")
            newBook.setValue(authorName.text, forKey: "author")
            
            // 4
            do {
                try managedContext.save()
                books.append(newBook)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        else
        {
            
        }
    }
    
    func getData()
    {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        //3
        do {
            books = try managedContext.fetch(fetchRequest) as! [Book]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
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
