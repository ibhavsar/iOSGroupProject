//
//  WelcomeViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-04-26.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController {
    var names: [NSManagedObject] = []
    
    @IBOutlet weak var theirNameField: UITextField!
    @IBOutlet weak var welcomeImage: UIImageView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var header: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "WelcomeData")
        
        do {
            names = try managedContext.fetch(fetchRequest) as! [WelcomeData]
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// for saving to core data
var userName = ""
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        print(names.count)
        if !names.isEmpty
        {
            names[0].setValue((name), forKey: "name")
            do {
                
                print("test2")
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error)")
            }
        }
    
    else {
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "WelcomeData",
                                       in: managedContext)!
        
        let named = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        named.setValue(name, forKeyPath: "name")
        
        // 4
      //  managedContext.delete(names[names.count -1])

        do {
            print("test3")

            try managedContext.save()
            names.append(named)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "WelcomeData")
        
        do {
            names = try managedContext.fetch(fetchRequest) as! [WelcomeData]
            userName = (names[0].value(forKey: "name") as? String)!

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    */
    

    @IBAction func nameChange(_ sender: Any) {
    }
  
    @IBAction func finished(_ sender: Any)
    {
        userName = theirNameField.text!
        _ = save(name: userName)
        theirNameField.removeFromSuperview()
        nextButton.isHidden = true
        welcomeImage.image = #imageLiteral(resourceName: "labelImage") // sets up next screen for navigation:
        header.image = #imageLiteral(resourceName: "HeaderRectangle")
    yesButton.isEnabled = true
        yesButton.isHidden = false
        skipButton.isHidden = false
        skipButton.isEnabled = true

       self.dismiss(animated: true, completion: nil)
    }
    
    
}
