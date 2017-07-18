//
//  AvatarSelectionViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-04-21.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class AvatarSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var theirName: String = ""
    var names: [NSManagedObject] = []
    var AvatarName: [NSManagedObject] = []
    //var avatarKey: Int = 0
    
    @IBOutlet weak var AvatarCollectionView: UICollectionView!
    var avatarImages = ["Avacado.png", "Bear.png", "Carrot.png", "Cow.png",  "Dinosaur.png", "Dolphin.png", "Elephant.png", "Flamingo.png", "Fox.png", "Hippo.png", "Jellyfish.png", "Monkey.png", "Octopus.png", "Panda.png", "Parrot.png", "Penguin.png", "Pig.png", "Platypus.png", "Popcorn.png", "Pumpkin.png", "Shark.png", "SHEEP.png", "SLOTH.png", "Wolf.png"] // this is the image names
    
    @IBOutlet weak var avatarLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if names.isEmpty
        {
            // fetching from core data to display
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate
                else {
                    return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WelcomeData")
            do {
                AvatarName = try managedContext.fetch(fetchRequest) as! [WelcomeData]
                names = try managedContext.fetch(fetchRequest) as! [WelcomeData]
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        theirName = names[0].value(forKey: "name") as! String
        
        // Do any additional setup after loading the view.
        self.AvatarCollectionView.delegate = self
        self.AvatarCollectionView.dataSource = self
        avatarLabel.text = "Hello, " + theirName + " please select an avatar"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! AvatarCollectionViewCell
        // set images
        cell.AvatarImageView.image = UIImage(named: avatarImages[indexPath.row])
        return cell
    }
    
    //coredata save func
    func save(name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        //
        let managedContext = appDelegate.persistentContainer.viewContext
        if !AvatarName.isEmpty {
            //    AvatarName.removeFirst("avatarSelected", forKey: "name")\\
            AvatarName[0].setValue(name, forKey: "avatarSelected")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error)")
            }
        }
        else {
            //
            let entity =
                NSEntityDescription.entity(forEntityName: "WelcomeData", in: managedContext)!
            
            let Avatname = NSManagedObject(entity: entity, insertInto: managedContext)
            
            //
            Avatname.setValue(name, forKeyPath: "avatarSelected")
            
            //
            do {
                try managedContext.save()
                AvatarName.append(Avatname)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var avatarImages = ["Avacado.png", "Bear.png", "Carrot.png", "Cow.png",  "Dinosaur.png", "Dolphin.png", "Elephant.png", "Flamingo.png", "Fox.png", "Hippo.png", "Jellyfish.png", "Monkey.png", "Octopus.png", "Panda.png", "Parrot.png", "Penguin.png", "Pig.png", "Platypus.png", "Popcorn.png", "Pumpkin.png", "Shark.png", "SHEEP.png", "SLOTH.png", "Wolf.png"] // this is the image names
     
        //single click for avatar selection
        save(name: avatarImages[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        
        //use for double click for avatar selection
//        if avatarKey == Int(indexPath.row)
//        {
//            let selectedAvatar = avatarImages[avatarKey] // avatar image name of one selected (save)
//            save(name : selectedAvatar)
//            self.dismiss(animated: true, completion: nil)
//        }
//        // this is the one they selected,
//        avatarKey = Int(indexPath.row)
    }
    
}
