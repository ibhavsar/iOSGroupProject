//
//  TodoSchedulingViewController.swift
//  iOSGroupProject
//
//  Created by Student on 2017-06-07.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit

class TodoSchedulingViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    @IBAction func savePressed(_ sender: UIButton) {
        let todoItem = TodoItem(deadline: deadlinePicker.date, title: titleField.text!, UUID: UUID().uuidString)
        TodoList.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
        let _ = self.navigationController?.popToRootViewController(animated: true) // return to list view
    }
}
