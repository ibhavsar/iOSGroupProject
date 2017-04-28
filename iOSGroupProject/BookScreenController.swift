//
//  BookScreenController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-04-21.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit

class BookScreenController: UIViewController {

    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func openTimerPage(_ sender: Any) {
        let thisStoryboard = UIStoryboard(name: "BookScreen", bundle: nil)
        let openedTimerPage = thisStoryboard.instantiateViewController(withIdentifier: "TimerPage") as? TimerPageController
        openedTimerPage?.oldTime = 3600
        openedTimerPage?.modalPresentationStyle = .popover
        
        let popoverController = openedTimerPage?.popoverPresentationController
        popoverController?.sourceView = sender as? UIView
        popoverController?.permittedArrowDirections = .any
        
        present(openedTimerPage!, animated: true, completion: nil)
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
