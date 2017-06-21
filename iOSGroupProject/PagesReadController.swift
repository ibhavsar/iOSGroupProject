//
//  PagesReadController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-06-08.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class PagesReadController: UIViewController, UITextFieldDelegate {

    var book: Int = 0
    var time: UIntMax = 0
    var totalTime: UIntMax = 3600
    
    var didChangeTime: Bool = false
    
    var books: [NSManagedObject] = []
    
    var currentSelectedTextField: UITextField? = nil
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var pages: UITextField!
    @IBOutlet weak var hours: UITextField!
    @IBOutlet weak var mins: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        hours.text = String(UIntMax(round(Double(totalTime - time) / 3600.0)))
        mins.text = String(UIntMax(round(Double((totalTime - time) % 3600) / 60.0)))
        // Do any additional setup after loading the view.
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentSelectedTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentSelectedTextField = nil
        if let pagesNum: UIntMax = UIntMax(pages.text!)
        {
            if pagesNum > 0
            {
                continueButton.isEnabled = true
            }
        }
        if (textField == hours || textField == mins) && hours.text != nil && hours.text != "" && mins.text != nil && mins.text != ""
        {
            time = UIntMax(hours.text!)! * 3600 + UIntMax(mins.text!)! * 60
            didChangeTime = true
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if currentSelectedTextField == hours || currentSelectedTextField == mins
            {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func `continue`(_ sender: Any) {
        let thisStoryboard = UIStoryboard(name: "BookScreen", bundle: nil)
        let openedTimerPage = thisStoryboard.instantiateViewController(withIdentifier: "SignaturePad") as? SignatureController
        
        openedTimerPage?.book = book
        openedTimerPage?.time = time
        openedTimerPage?.totalTime = totalTime
        openedTimerPage?.didChangeTime = didChangeTime
        if let pagesNum: Int = Int(pages.text!)
        {
            openedTimerPage?.pages = pagesNum
        }
        else
        {
            print("Error could not save pages.")
        }
        
        self.revealViewController().setFront(openedTimerPage, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        let thisStoryboard = UIStoryboard(name: "BookScreen", bundle: nil)
        let openedTimerPage = thisStoryboard.instantiateViewController(withIdentifier: "TimerPage") as? TimerPageController
        openedTimerPage?.book = book
        
        self.revealViewController().setFront(openedTimerPage, animated: true)
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
