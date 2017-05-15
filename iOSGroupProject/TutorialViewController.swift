//
//  TutorialViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-05-11.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var back_from_tuto: UIButton!
    @IBOutlet weak var back_to_first: UIButton!
    @IBOutlet weak var back_Screen6: UIButton!
    @IBOutlet weak var back_Screen_8a: UIButton!
    @IBOutlet weak var next_screen10: UIButton!
    @IBOutlet weak var dismiss_button: UIButton!
    @IBOutlet weak var next_screen8b: UIButton!
    @IBOutlet weak var next_screen8a: UIButton!
    @IBOutlet weak var next_screen6: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     performSegue(withIdentifier: "about", sender: sender)

    }
    */

  

    
    @IBAction func next_to_screen6(_ sender: Any) {
        self.performSegue(withIdentifier: "toScreen6", sender: self)

    }
    
    @IBAction func next_to_screen8a(_ sender: Any) {
        self.performSegue(withIdentifier: "toScreen8a", sender: self)
    }
    
    @IBAction func next_to_screen8b(_ sender: Any) {
        self.performSegue(withIdentifier: "toScreen8b", sender: self)
    }
    

    @IBAction func next_to_screen10(_ sender: Any) {
        self.performSegue(withIdentifier: "toScreen10", sender: self)

    }
    @IBAction func dimiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back_to_screen8a(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
  
    }
    
    @IBAction func back_to_screen6(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func back_to_first(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func go_back_from_tutorial(_ sender: Any) {
    //    self.dismiss(animated: true, completion: nil)

    }
}
