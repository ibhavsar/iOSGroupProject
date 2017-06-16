//
//  AchievementsViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-04-19.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class AchievementsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var AchieveCollectionView: UICollectionView!
    var achievements = ["BookPhotoUnachieved", "BookwormUnachieved", "PagesUnachieved", "SignaturesUnachieved", "StreakUnachieved", "TagsUnachieved"]
    var progresses: [Float] = [0,0,0,0,0,0]
    var books: [NSManagedObject] = []
    var bookPics: [NSManagedObject] = []
    var progress: Float = 0.0
    var pages = 0
    var imageNum = 0
    var imageCount = 0
    var totalPages = 0
    var bookNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        do {
            books = try managedContext.fetch(fetchRequest) as! [Book]
            bookPics = try managedContext.fetch(fetchRequest) as! [Book]
            print ("\(bookPics.count)")
            if bookPics.count > 0 {
                for i in 0...(bookPics.count-1) {
                pages = books[i].value(forKey: "pagesRead") as! Int
                totalPages = books[i].value(forKey: "pages") as! Int
               let imageNu = books[i].value(forKey: "image") as? NSData
                if totalPages == pages && totalPages != 0 {
                    bookNumber = bookNumber + 1
                    if totalPages > 1500 {
                        achievements[5] = "Tags6"
                    }
                    else if totalPages > 1000 {
                        achievements[5] = "Tags5"
                    }
                    else if totalPages > 500 {
                        achievements[5] = "Tags4"
                    }
                    else if totalPages > 250 {
                        achievements[5] = "Tags3"
                    }
                    else if totalPages > 100 {
                        achievements[5] = "Tags2"
                    }
                    else if totalPages > 50 {
                        achievements[5] = "Tags1"
                    }
                    if imageNu == nil {
                        imageNum = imageNum - 1
                    }
                    }
                }
            }
            switch bookNumber {
            case 1:
            achievements[1] = "Bookworm1"
            case 5:
            achievements[1] = "Bookworm2"
            case 2..<5:
            progress = Float(bookNumber/3)
            case 10:
            achievements[1] = "Bookworm3"
            case 6..<10:
                progress = Float((bookNumber-5)/4)
            case 25:
            achievements[1] = "Bookworm4"
            case 26..<50:
                progress = ((roundf(Float(bookNumber/10)))/3)
            case 50:
            achievements[1] = "Bookworm5"
            case 51..<100:
                progress = Float((bookNumber-50)/10)
            case 100:
            achievements[1] = "Bookworm6"
            default:
            achievements[1] = "BookwormUnachieved"
            }
            
            switch imageNum {
            case 1:
                achievements[0] = "BookPhoto1"
            case 2..<5:
                progress = Float(imageNum/3)
            case 5:
                achievements[0] = "BookPhoto2"
            case 6..<10:
                progress = Float((imageNum-5)/4)
            case 10:
                achievements[0] = "BookPhoto3"
            case 25:
                achievements[0] = "BookPhoto4"
            case 26..<50:
                progress = ((roundf(Float(imageNum/10)))/3)
            case 50:
                achievements[0] = "BookPhoto5"
            case 51..<100:
                progress = Float((imageNum-50)/10)
            case 100:
                achievements[0] = "BookPhoto6"
            default:
                achievements[0] = "BookPhotoUnachieved"

            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        

        self.AchieveCollectionView.delegate = self
        self.AchieveCollectionView.dataSource = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievements.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "achieve_collection_cell", for: indexPath) as! AchieveCollectionViewCell
        cell.AchieveImageView.image = UIImage(named: achievements[indexPath.row])
        print("\(progresses[indexPath.row])")
        if progresses[indexPath.row] > 0{
      cell.progressView.progress = progresses[indexPath.row]
        }// an array of what the progress view should have
        return cell
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
