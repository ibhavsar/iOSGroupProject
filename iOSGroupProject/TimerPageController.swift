//
//  TimerPageController.swift
//  GroupProjectGit
//
//  Created by Student on 2017-03-27.
//  Copyright © 2017 Stephen. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class TimerPageController: UIViewController {
    
    var alarmPlayer: AVAudioPlayer!

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var book = 0
    
    var books: [NSManagedObject] = []
    
    var totalTime: UIntMax = 3600
    
    var time:UIntMax = 3600
    
    var timer = Timer()
    
    var alarm: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        if book < books.count
        {
            time = books[book].value(forKey: "lastTimeRead") as! UIntMax
            totalTime = time
        }
        else
        {
            print("Error Reading file.")
        }
        
        updateTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveTimeDone()
    }
    
    //starts the timer when the start button is pressed
    @IBAction func startTimer(_ sender: Any) {
        //runs the start function if set to start
        if startButton.title(for: .normal) == "Start"
        {
            //starts the timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            
            //sets the button to say stop
            startButton.setTitle("Stop", for: .normal)
        }
        else if startButton.title(for: .normal) == "Stop"
        {
            //stops the timer
            timer.invalidate()
            
            if alarmPlayer != nil && alarmPlayer.isPlaying {
                alarmPlayer.stop()
                alarmPlayer = nil
            }
            
            //sets the button to say start
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    //stops the timer and resets the timer to the default number
    @IBAction func resetTimer(_ sender: Any) {
        timer.invalidate()
        time = books[book].value(forKey: "lastTimeRead") as! UIntMax
        
        //sets the button to say start
        startButton.setTitle("Start", for: .normal)
        
        updateTime()
    }
    
    func updateCounter()
    {
        //reduces the timer every second by one second
        if time > 0
        {
            time -= 1
            
            updateTime()
            
            alarm = true
        }
            //stops the timer and sets off the alarm when the timer has run out
        else
        {
            if alarm
            {
                timerEnd()
                
                //sets the view to show the time
                timeLabel.text = "00:00:00"
                
                alarm = false
            }
        }
    }
    func timerEnd()
    {
        let path = Bundle.main.path(forResource: "Annoying_Alarm_Clock" , ofType:"mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            self.alarmPlayer = sound
            sound.numberOfLoops = 10
            sound.prepareToPlay()
            sound.play()
        } catch {
            print("error loading file")
            // couldn't load file :(
        }
    }
    
    func updateTime()
    {
        //sets the view to show the time
        timeLabel.text = (((time/3600) < 10) ?  ("0" + String(time/3600)) : (String(time/3600))) + ":" + ((((time % 3600) / 60) < 10) ?  ("0" + String((time % 3600) / 60)) : (String((time % 3600) / 60))) + ":" + ((((time % 3600) % 60) < 10) ?  ("0" + String((time % 3600) % 60)) : (String((time % 3600) % 60)))
    }
    
    @IBAction func plus1Hour(_ sender: Any) {
        //adds an hour to the time left
        time += 3600
        totalTime += 3600
        
        updateTime()
    }
    
    @IBAction func minus1Hour(_ sender: Any) {
        //checks to make sure there is an hour to remove
        if time >= 3600
        {
            //removes the hour
            time -= 3600
            totalTime -= 3600
        }
        else
        {
            totalTime -= time
            time = 0
        }
        
        updateTime()
    }
    
    @IBAction func plus30Mins(_ sender: Any) {
        //adds half an hour to the time left
        time += 1800
        totalTime += 1800
        
        updateTime()
    }
    
    @IBAction func minus30Mins(_ sender: Any) {
        //checks to make sure there is 30 mins to remove
        if time >= 1800
        {
            time -= 1800
            totalTime -= 1800
        }
        else
        {
            totalTime -= time
            time = 0
        }
        
        updateTime()
    }
    
    @IBAction func plus1Min(_ sender: Any) {
        //adds a min to the time left
        time += 60
        totalTime += 60
        
        updateTime()
    }
    
    @IBAction func minus1Min(_ sender: Any) {
        //checks to make sure there is an min to remove
        if time >= 60
        {
            time -= 60
            totalTime -= 60
        }
        else
        {
            totalTime -= time
            time = 0
        }
        
        updateTime()
    }
    
    @IBAction func close(sender: AnyObject) {
        if alarmPlayer != nil && alarmPlayer.isPlaying {
            alarmPlayer.stop()
            alarmPlayer = nil
        }
        
        self.dismiss(animated: false, completion: nil)
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
            NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        //3
        do {
            books = try managedContext.fetch(fetchRequest) as! [Book]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
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
            
            // 4
            do {
                try managedContext.save()
                books.append(newBook)
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
        }
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
