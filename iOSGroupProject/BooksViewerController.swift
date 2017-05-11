//
//  BooksViewerController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-05-04.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class BooksViewerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var AvatarCollectionView: UICollectionView!
    
    var books: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.AvatarCollectionView.delegate = self
        self.AvatarCollectionView.dataSource = self
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (books.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Book_View_Cell", for: indexPath) as! BookViewCell
        
        // set images
        if indexPath.row < books.count
        {
            let imageData = books[indexPath.row].value(forKey: "image") as? NSData
            
            if imageData != nil
            {
                let newImage: UIImage? = UIImage(data: imageData as! Data)
                if newImage != nil
                {
                    cell.BookPreview.image = newImage
                }
                else
                {
                    cell.BookPreview.image = nil
                }
            }
            else
            {
                cell.BookPreview.image = #imageLiteral(resourceName: "Camera Box")
            }
            
            cell.BookTitle.text = books[indexPath.row].value(forKey: "title") as? String
        }
        else
        {
            cell.BookPreview.image = #imageLiteral(resourceName: "BluePlus")
            cell.BookTitle.text = "New Book"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == books.count
        {
            save()
        }
        
        bookb = indexPath.row as Int
        
        self.dismiss(animated: true, completion: nil)
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
    
    func save() {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Book",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 4
        do {
            try managedContext.save()
            books.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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