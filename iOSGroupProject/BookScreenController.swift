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
    
    var book = 0
    
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        getData()
        if !books.isEmpty
        {
            ratingView.rating = books[book].value(forKey: "rating") as! Float
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openTimerPage(_ sender: Any) {
        saveRating()
        
        let thisStoryboard = UIStoryboard(name: "BookScreen", bundle: nil)
        let openedTimerPage = thisStoryboard.instantiateViewController(withIdentifier: "TimerPage") as? TimerPageController
        openedTimerPage?.book = book
        openedTimerPage?.modalPresentationStyle = .popover
        
        let popoverController = openedTimerPage?.popoverPresentationController
        popoverController?.sourceView = sender as? UIView
        popoverController?.permittedArrowDirections = .any
        
        present(openedTimerPage!, animated: true, completion: nil)
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
        if !books.isEmpty
        {
            books[book].setValue(ratingView.rating, forKey: "rating")
        }
        else
        {
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
            
            let newBook = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
