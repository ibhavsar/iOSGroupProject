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
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    var books: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bookCollectionView.delegate = self
        self.bookCollectionView.dataSource = self
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
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
                let newImage: UIImage? = UIImage(data: imageData! as Data)
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
            let thisStoryboard = UIStoryboard(name: "BookSaving", bundle: nil)
            
            let bookSaving = thisStoryboard.instantiateViewController(withIdentifier: "BookSave") as? BookTitleViewController
            
            self.revealViewController().setFront(bookSaving, animated: true)
        }
        else
        {
            let thisStoryboard = UIStoryboard(name: "BookScreen", bundle: nil)
            
            let bookSaving = thisStoryboard.instantiateViewController(withIdentifier: "BookNavController")
        
            (bookSaving.childViewControllers[0] as! BookScreenController).book = indexPath.row
            
            self.revealViewController().setFront(bookSaving, animated: true)
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
