//
//  SignatureController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-06-05.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

class SignatureController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    @IBOutlet weak var pagesRead: UILabel!
    @IBOutlet weak var timeRead: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var message: UILabel!
    
    var book: Int = 0
    var time: UIntMax = 0
    var totalTime: UIntMax = 0
    var pages: Int = 0
    var signature: Int = 0
    var didChangeTime: Bool = false
    
    var books: [NSManagedObject] = []
    
    var signatures: [NSManagedObject] = []
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        getBookData()
        
        signature = signatures.count
        
        var timeDif:UIntMax = time
        
        if !didChangeTime
        {
            timeDif = totalTime - time
        }
        
        if pages > books[book].value(forKeyPath: "pages") as! Int
        {
            pages = books[book].value(forKeyPath: "pages") as! Int
        }
        
        timeRead.text = "Time Read: " + (((timeDif/3600) < 10) ?  ("0" + String(timeDif/3600)) : (String(timeDif/3600))) + ":" + ((((timeDif % 3600) / 60) < 10) ?  ("0" + String((timeDif % 3600) / 60)) : (String((timeDif % 3600) / 60))) + ":" + ((((timeDif % 3600) % 60) < 10) ?  ("0" + String((timeDif % 3600) % 60)) : (String((timeDif % 3600) % 60)))
        pagesRead.text = "Pages Read:          " + String(pages)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func reset(_ sender: AnyObject) {
        mainImageView.image = nil
        message.isHidden = false
        continueButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        continueButton.isHidden = true
        backButton.isHidden = true
        message.isHidden = true
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // 3
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        // 4
        context?.strokePath()
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
        
        if mainImageView == nil
        {
            message.isHidden = false
        }
        
        continueButton.isEnabled = true
        continueButton.isHidden = false
        backButton.isHidden = false
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
            NSFetchRequest<NSFetchRequestResult>(entityName: "Signatures")
        
        //3
        do {
            signatures = try managedContext.fetch(fetchRequest) as! [Signatures]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if signature < signatures.count
        {
            signatures[signature].setValue(book, forKey: "book")
            
            if mainImageView != nil
            {
                let imageData = UIImagePNGRepresentation(mainImageView.image!) as NSData?
                
                signatures[signature].setValue(imageData, forKey: "signatureImage")
            }
            
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            
            signatures[signature].setValue(components.day, forKey: "day")
            signatures[signature].setValue(components.month, forKey: "month")
            signatures[signature].setValue(components.year, forKey: "year")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
        }
        else
        {
            // 2
            let entity = NSEntityDescription.entity(forEntityName: "Signatures", in: managedContext)!
            
            let newSignature = NSManagedObject(entity: entity, insertInto: managedContext)
            
            newSignature.setValue(book, forKey: "book")
            
            if mainImageView != nil
            {
                let imageData = UIImagePNGRepresentation(mainImageView.image!) as NSData?
                
                newSignature.setValue(imageData, forKey: "signatureImage")
            }
            
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            
            newSignature.setValue(components.day, forKey: "day")
            newSignature.setValue(components.month, forKey: "month")
            newSignature.setValue(components.year, forKey: "year")
            
            // 4
            do {
                try managedContext.save()
                signatures.append(newSignature)
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
        }
    }
    
    func saveTimeDone() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if book < books.count
        {
            books[book].setValue((totalTime), forKey: "lastTimeRead")
            totalTime += books[book].value(forKey: "timeRead") as! UIntMax
            books[book].setValue((totalTime - time), forKey: "timeRead")
            books[book].setValue(pages, forKey: "pagesRead")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
        }
        else
        {
            // 2
            let entity = NSEntityDescription.entity(forEntityName: "Book", in: managedContext)!
            
            let newBook = NSManagedObject(entity: entity, insertInto: managedContext)
            
            newBook.setValue((totalTime), forKey: "lastTimeRead")
            newBook.setValue((totalTime  - time), forKey: "timeRead")
            newBook.setValue(pages, forKey: "pagesRead")
            
            // 4
            do {
                try managedContext.save()
                books.append(newBook)
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
        }
    }
    
    func getBookData()
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
    
    @IBAction func `continue`(_ sender: Any) {
        save()
        saveTimeDone()
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
