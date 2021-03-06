//
//  BookScreenController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-04-21.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class BookScreenController: UIViewController {

    var books: [NSManagedObject] = []
    var book: Int? = nil

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var Pages: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeTotalRead: UILabel!
    
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if book == nil
        {
            openBookSelector()
        }
        else
        {
            getData()
            
            if book! < books.count
            {
                ratingView.rating = books[book!].value(forKey: "rating") as! Float
                
                updateTimeRead()
                
                titleLabel.text = books[book!].value(forKey: "title") as? String
            }
            else
            {
                print("Error Reading file.")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
        
        if book != nil
        {
            if book! < books.count
            {
                ratingView.rating = books[book!].value(forKey: "rating") as! Float
                
                updateTimeRead()
                
                titleLabel.text = books[book!].value(forKey: "title") as? String
                
                let pages = books[book!].value(forKey: "pages")!
                let pagesRead = books[book!].value(forKey: "pagesRead")!
                
                Pages.text = String(describing: pagesRead) + "/" + String(describing: pages)
                
                let imageData = books[book!].value(forKey: "image") as? NSData
                
                if imageData != nil
                {
                    let newImage: UIImage? = UIImage(data: imageData! as Data)
                    if newImage != nil
                    {
                        imageView.image = newImage
                    }
                    else
                    {
                        imageView.image = nil
                    }
                }
                else
                {
                    imageView.image = #imageLiteral(resourceName: "Camera Box")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if book != nil
        {
            saveRating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func openTimerPage(_ sender: Any) {
        if book != nil
        {
            saveRating()
            
            let thisStoryboard = UIStoryboard(name: "BookScreen", bundle: nil)
            let openedTimerPage = thisStoryboard.instantiateViewController(withIdentifier: "TimerPage") as? TimerPageController
            openedTimerPage?.book = book!
            
            self.revealViewController().setFront(openedTimerPage, animated: true)
        }
    }
    
    @IBAction func openBooksScreen(_ sender: Any) {
        openBookSelector()
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
    
    func saveRating() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if book! < books.count
        {
            books[book!].setValue(ratingView.rating, forKey: "rating")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
        }
        else
        {
            // 2
            let entity = NSEntityDescription.entity(forEntityName: "Book", in: managedContext)!
            
            let newBook = NSManagedObject(entity: entity, insertInto: managedContext)
            
            // 3
            newBook.setValue(ratingView.rating, forKey: "rating")
            
            // 4
            do {
                try managedContext.save()
                books.append(newBook)
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
        }
    }
    
    func updateTimeRead()
    {
        if book! < books.count
        {
            let time = books[book!].value(forKey: "timeRead") as! UIntMax
            
            timeTotalRead.text = (((time/3600) < 10) ?  ("0" + String(time/3600)) : (String(time/3600))) + ":" + ((((time % 3600) / 60) < 10) ?  ("0" + String((time % 3600) / 60)) : (String((time % 3600) / 60))) + ":" + ((((time % 3600) % 60) < 10) ?  ("0" + String((time % 3600) % 60)) : (String((time % 3600) % 60)))
        }
        else
        {
            print("Error Reading file.")
        }
    }
    
    func openBookSelector()
    {
        let thisStoryboard = UIStoryboard(name: "BookScreen", bundle: nil)
        
        let bookSelection = thisStoryboard.instantiateViewController(withIdentifier: "BookSelection") as? BooksViewerController
        
        self.revealViewController().pushFrontViewController(bookSelection, animated: true)
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
