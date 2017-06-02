//
//  WelcomeViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-04-26.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    var names: [NSManagedObject] = []
    
    @IBOutlet weak var theirNameField: UITextField!
    @IBOutlet weak var welcomeImage: UIImageView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var header: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        self.theirNameField.delegate = self;
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "WelcomeData")
        
        do {
            names = try managedContext.fetch(fetchRequest) as! [WelcomeData]
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if names.count > 0
        {
            if names[0].value(forKey: "name") != nil
            {
                if !skipButton.isEnabled
                {
                    let thisStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let doneMain = thisStoryboard.instantiateViewController(withIdentifier: "main")
                    doneMain.modalPresentationStyle = .overCurrentContext
                    self.dismiss(animated: true, completion: nil)
                    self.present(doneMain, animated: false, completion: nil)
                }
            }
        }
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
    
// for saving to core data
var userName = ""
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        if !names.isEmpty
        {
            names[0].setValue(name, forKey: "name")
            do {
                
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error)")
            }
        }
        else {
            // 2
            let entity = NSEntityDescription.entity(forEntityName: "WelcomeData", in: managedContext)!
            
            let named = NSManagedObject(entity: entity, insertInto: managedContext)
            
            // 3
            named.setValue(name, forKeyPath: "name")
            
            do {
                try managedContext.save()
                names.append(named)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    @IBAction func finished(_ sender: Any)
    {
        userName = theirNameField.text!
        _ = save(name: userName)
        theirNameField.removeFromSuperview()
        nextButton.isHidden = true
        welcomeImage.image = #imageLiteral(resourceName: "labelImage") // sets up next screen for navigation:
        header.image = #imageLiteral(resourceName: "HeaderRectangle")
        skipButton.isHidden = false
        skipButton.isEnabled = true
        yesButton.isEnabled = true
        yesButton.isHidden = false
        
        self.dismiss(animated: true, completion: nil)
    }
}
