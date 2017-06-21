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
    var caption: [String] = [" "," "," "," "," ", " "]
    var signatures: [NSManagedObject] = []
    var numSigs = 0
    var prevSig = 0
    var streak = 0
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
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Signatures")
        do {
            books = try managedContext.fetch(fetchRequest) as! [Book]
            books = try managedContext.fetch(fetchRequest) as! [Book]
            signatures = try managedContext.fetch(fetchRequest2) as! [Signatures]
            bookPics = try managedContext.fetch(fetchRequest) as! [Book]
            print ("\(bookPics.count)")
            print ("\(signatures.count)")
            if signatures.count > 0 {
                for i in 0...(signatures.count - 1) {
             let numSigss = signatures[i].value(forKey: "day") as! Int
                    if i > 0 {
             prevSig = signatures[i-1].value(forKey: "day") as! Int
                    }
                    if numSigss != 0 && streak != 1{
                    numSigs = numSigs + 1
                    streak = 1
                    }
                    if numSigss - prevSig == 0 || (prevSig == 30 && numSigss == 1) || (prevSig == 31 && numSigss == 1){
                        streak = streak + 1
                        print("\(streak)")
                    }
                }
            }
            if bookPics.count > 0 {
                for i in 0...(bookPics.count-1) {
                    pages = books[i].value(forKey: "pagesRead") as! Int
                    totalPages = books[i].value(forKey: "pages") as! Int
                    let imageNu = books[i].value(forKey: "image") as? NSData
                    if totalPages == pages && totalPages != 0 {
                        bookNumber = bookNumber + 1
                        if totalPages > 1500 {
                            achievements[5] = "Tags6"
                            caption[5] = "Reading a book with 1500 pages is really impressive! You’ve become a master at reading!"
                        }
                        else if totalPages >= 1000 {
                            achievements[5] = "Tags5"
                            caption[5] = "“A 1000 page book! That is gigantic!"
                        }
                        else if totalPages >= 500 {
                            achievements[5] = "Tags4"
                            caption[5] = "Wow! 500 pages! That’s a huge book!"
                        }
                        else if totalPages >= 250 {
                            achievements[5] = "Tags3"
                            caption[5] = "A 250 page book! You’re getting big!"
                        }
                        else if totalPages >= 100 {
                            achievements[5] = "Tags2"
                            caption[5] = "You’ve read a 100 page book! Good going!"
                        }
                        else if totalPages >= 50 {
                            achievements[5] = "Tags1"
                            caption[5] = "Just starting out! You’ve read a book with 50 pages!"
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
                caption[1] = "Nice, you read your first book!"
            case 5:
                achievements[1] = "Bookworm2"
                caption[1] = "Wow 5 whole books! That’s impressive!"
            case 2..<5:
                achievements[1] = "Bookworm1"
                progresses[1] = Float(Double(bookNumber) / 5)
                print("This is \(bookNumber)")
                print("This is \(progresses[1])")
            case 10:
                achievements[1] = "Bookworm3"
                caption[1] = "You’ve read 10 books! That’s great progress!"
            case 6..<10:
                progresses[1] = Float(Double(bookNumber-5) / 5)
                achievements[1] = "Bookworm2"
            case 11..<25:
                progresses[1] = Float(Double(bookNumber-10) / 14)
                achievements[1] = "Bookworm2"
            case 25:
                achievements[1] = "Bookworm4"
                caption[1] = " 25 Books! Thats a lot of books! Keep Reading!"
            case 26..<50:
                achievements[1] = "Bookworm4"
                progresses[1] = Float(Double(bookNumber-25) / 24)
            case 50:
                achievements[1] = "Bookworm5"
                caption[1] = " 50 books! That’s extraordinary!"
            case 51..<100:
                achievements[1] = "Bookworm5"
                progresses[1] = Float(Double(bookNumber-50) / 50)
            case 100:
                achievements[1] = "Bookworm6"
                caption[1] = " Your hundredth book! That’s phenomenal!"
            default:
                achievements[1] = "BookwormUnachieved"
            }
            
            switch imageNum {
            case 1:
                achievements[0] = "BookPhoto1"
                caption[0] = "You took your first photo of a book!"
            case 2..<5:
                achievements[0] = "BookPhoto1"
                progresses[0] = Float(Double(imageNum) / 5)
            case 5:
                achievements[0] = "BookPhoto2"
                caption[0] = "You’re getting the hang of it, you took your fifth picture of a book!"
            case 6..<10:
                achievements[0] = "BookPhoto2"
                progresses[0] = Float(Double(imageNum-5) / 5)
            case 10:
                achievements[0] = "BookPhoto3"
                caption[0] = "You’re a master of images! You’ve taken 10 pictures of books!"
            case 11..<25:
                progresses[0] = Float(Double(imageNum-10) / 14)
                achievements[0] = "BookPhoto3"
            case 25:
                achievements[0] = "BookPhoto4"
                caption[0] = "You’ve taken 25 pictures!"
            case 26..<50:
                achievements[0] = "BookPhoto4"
                progresses[0] = Float(Double(imageNum-25) / 24)
            case 50:
                achievements[0] = "BookPhoto5"
                caption[0] = "You’ve taken 50 pictures of books!"
            case 51..<100:
                achievements[0] = "BookPhoto5"
                progresses[0] = Float(Double(imageNum-50) / 50)
            case 100:
                achievements[0] = "BookPhoto6"
                caption[0] = "You made it! You’ve reached 100 pictures of books!"
            default:
                achievements[0] = "BookPhotoUnachieved"
            }
            
            switch numSigs {
            case 1:
                achievements[3] = "Signatures1"
                caption[3] = "Parental guidance improved! Your parent or guardian has signed off a book!"
            case 2..<5:
                achievements[3] = "Signatures1"
                progresses[3] = Float(Double(numSigs) / 5)
            case 5:
                achievements[3] = "Signatures2"
                caption[3] = "5 Signatures! Keep it Up!"
            case 6..<10:
                achievements[3] = "Signatures2"
                progresses[3] = Float(Double(numSigs-5) / 5)
            case 11..<25:
                progresses[3] = Float(Double(numSigs-10) / 14)
                achievements[3] = "Signatures3"
            case 10:
                achievements[3] = "Signatures3"
                caption[3] = "You must be a spy! You’ve gotten your parents to sign off 10 books!"
            case 25:
                achievements[3] = "Signatures4"
                caption[3] = "Access Granted! Your parents have signed 25 times."
            case 26..<50:
                achievements[3] = "Signatures4"
                progresses[3] = Float(Double(numSigs-25) / 24)
            case 50:
                achievements[3] = "Signatures5"
                caption[3] = "That’s a lot of signing! Your parents gave you their autograph 50 times!"
            case 51..<100:
                achievements[3] = "Signatures5"
                progresses[3] = Float(Double(numSigs-50) / 50)
            case 100:
                achievements[3] = "Signatures6"
                caption[3] = "You have Superpowers! Your parents managed to sign off a book 100 times!"
            default:
                achievements[3] = "SignaturesUnachieved"
            }
            
            switch streak {
            case 1:
                achievements[4] = "Streak1"
                caption[4] = "First Day Reading! Start the journey!"
            case 2:
                achievements[4] = "Streak1"
                progresses[4] = Float(0.5)
            case 3:
                achievements[4] = "Streak2"
                caption[4] = "3 days straight! NICE!"
            case 4..<7:
                achievements[4] = "Streak2"
                progresses[4] = Float(Double(streak-3) / 4)
            case 8..<14:
                progresses[4] = Float(Double(streak-7) / 6)
                achievements[4] = "Streak3"
            case 7:
                achievements[4] = "Streak3"
                caption[4] = " One week streak!"
            case 14:
                achievements[4] = "Streak4"
                caption[4] = "When are you gonna stop! It’s been 14 days reading!"
            case 15..<30:
                achievements[4] = "Streak4"
                progresses[4] = Float(Double(streak-14) / 16)
            case 30:
                achievements[4] = "Streak5"
                caption[4] = "One Month of reading straight! You’re a boss!"
            case 31..<60:
                achievements[4] = "Streak5"
                progresses[4] = Float(Double(streak-30) / 29)
            case 60:
                achievements[4] = "Streak6"
                caption[4] = "WOW 60 days reading!"
                
            default:
                achievements[4] = "StreakUnachieved"
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
        let temp = caption[indexPath.row]
        print ("\(temp)")
        cell.captionLabel.text = temp
       // cell.captionLabel.text = ("\(caption[indexPath.row])")
        print("\(progresses[indexPath.row])")
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
