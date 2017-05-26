//
//  PictureViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-05-18.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class PictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var books: [NSManagedObject] = []
    
    var book = 0
    
    var imagePicker: UIImagePickerController!
    
    var bookTitle: String = ""
    var numberOfPages: Int = 0
    var authorsName: String = ""
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var textView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        
        getData()
        
        book = books.count
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openPhoto))
        
        view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func `continue`(_ sender: Any) {
        save()
        self.dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func openPhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "Could not access a camera.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            nextButton.isEnabled = true
        }
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        background.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        cameraImage.isHidden = true
        textView.isHidden = true
        nextButton.isEnabled = true
        
        save()
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
            
            if cameraImage.isHidden
            {
                let imageData = UIImagePNGRepresentation(background.image!) as NSData?
                
                newBook.setValue(imageData, forKey: "image")
            }
            
            newBook.setValue(bookTitle, forKey: "title")
            newBook.setValue(numberOfPages, forKey: "pages")
            newBook.setValue(authorsName, forKey: "author")
            
            // 4
            do {
                try managedContext.save()
                books.append(newBook)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
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
