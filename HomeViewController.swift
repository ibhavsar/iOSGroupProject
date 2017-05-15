//
//  HomeViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-04-19.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    var avatarNames: [NSManagedObject] = []
    var avatarName = ""
    
    @IBOutlet weak var changeAvatarButton: UIButton!
    @IBOutlet weak var avatarDisplay: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var startReadButton: UIButton!
    @IBOutlet weak var achieveLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WelcomeData")
        do {
            avatarNames = try managedContext.fetch(fetchRequest) as! [WelcomeData]
            print (avatarNames.count)
            avatarName = avatarNames[0].value(forKey: "avatarSelected") as! String
            print(avatarName + "lololol")
            avatarDisplay.image = UIImage(named: avatarName)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
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
    
    @IBAction func changeAvatar(_ sender: Any) {
        self.performSegue(withIdentifier: "toAvatar", sender: self)
     // UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "HomeViewController")
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
