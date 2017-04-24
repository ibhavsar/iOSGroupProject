//
//  TimerPageController.swift
//  GroupProjectGit
//
//  Created by Student on 2017-03-27.
//  Copyright © 2017 Stephen. All rights reserved.
//

import UIKit

class TimerPageController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var time:UIntMax = 3600
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            //sets the button to say start
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    //stops the timer and resets the timer to the default number
    @IBAction func resetTimer(_ sender: Any) {
        timer.invalidate()
        time = 3600
        
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
        }
            //stops the timer and sets off the alarm when the timer has run out
        else
        {
            timerEnd()
            
            //sets the view to show the time
            timeLabel.text = "00:00:00"
        }
    }
    
    func timerEnd()
    {
        
    }
    
    func updateTime()
    {
        //sets the view to show the time
        timeLabel.text = (((time/3600) < 10) ?  ("0" + String(time/3600)) : (String(time/3600))) + ":" + ((((time % 3600) / 60) < 10) ?  ("0" + String((time % 3600) / 60)) : (String((time % 3600) / 60))) + ":" + ((((time % 3600) % 60) < 10) ?  ("0" + String((time % 3600) % 60)) : (String((time % 3600) % 60)))
    }
    
    @IBAction func plus1Hour(_ sender: Any) {
        //adds an hour to the time left
        time += 3600
        
        updateTime()
    }
    
    @IBAction func minus1Hour(_ sender: Any) {
        //checks to make sure there is an hour to remove
        if time >= 3600
        {
            //removes the hour
            time -= 3600
        }
        
        updateTime()
    }
    
    @IBAction func plus30Mins(_ sender: Any) {
        //adds half an hour to the time left
        time += 1800
        
        updateTime()
    }
    
    @IBAction func minus30Mins(_ sender: Any) {
        //checks to make sure there is 30 mins to remove
        if time >= 1800
        {
            time -= 1800
        }
        
        updateTime()
    }
    
    @IBAction func plus1Min(_ sender: Any) {
        //adds a min to the time left
        time += 60
        
        updateTime()
    }
    
    @IBAction func minus1Min(_ sender: Any) {
        //checks to make sure there is an min to remove
        if time >= 60
        {
            time -= 60
        }
        
        updateTime()
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
