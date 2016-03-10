//
//  SettingsMenuController.swift
//  RafaiOSTask
//
//  Created by Saraceni on 3/8/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import UIKit

class SettingsMenuController: UITableViewController {

    
    @IBOutlet var windowTextField: UITextField!
    @IBOutlet var sortTextField: UITextField!
    @IBOutlet var showViralSwitch: UISwitch!
    
    
    
    let windowPicker = UIPickerView()
    let windowOptions = [Prefs.WindowDay, Prefs.WindowAll, Prefs.WindowMonth, Prefs.WindowWeek, Prefs.WindowYear]
    
    let sortPicker = UIPickerView()
    let sortOptions = [Prefs.SortViral, Prefs.SortTop, Prefs.SortTime, Prefs.SortRising]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let doneBt = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "hidePickers")
        doneBt.tintColor = UIColor.whiteColor()
        
        
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        toolBar.barStyle = UIBarStyle.BlackOpaque
        toolBar.setItems([doneBt], animated: true)
        
        windowPicker.dataSource = self
        windowPicker.delegate = self
        
        windowTextField.inputAccessoryView = toolBar
        windowTextField.inputView = windowPicker
        
        sortPicker.dataSource = self
        sortPicker.delegate = self
        
        sortTextField.inputAccessoryView = toolBar
        sortTextField.inputView = sortPicker
        
        if let selectedWindow = Prefs.getWindow() {
            windowTextField.text = selectedWindow
        }
        
        if let selectedSort = Prefs.getSort() {
            sortTextField.text = selectedSort
        }
        
        let showViral = Prefs.getShowViral()
        showViralSwitch.setOn(showViral, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hidePickers() {
        windowTextField.resignFirstResponder()
        sortTextField.resignFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirmAction(sender: UIBarButtonItem) {
        saveSettingsState()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // TODO:
    func saveSettingsState(){
        
        let selectedWindow = windowTextField.text!
        Prefs.setWindow(selectedWindow)
        
        let selectedSort = sortTextField.text!
        Prefs.setSort(selectedSort)
        
        let showViral = showViralSwitch.on
        Prefs.setShowViral(showViral)
        
        
        if let navigationController = self.navigationController?.presentingViewController as? UINavigationController {
            
            if let viewController = navigationController.viewControllers[0] as? ViewController {
                viewController.shouldUpdatePreferences = true
            }
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - UIPicker Methods
extension SettingsMenuController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == windowPicker {
            return windowOptions.count
        }
        else if pickerView == sortPicker {
            return sortOptions.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == windowPicker {
            return windowOptions[row]
        }
        else if pickerView == sortPicker {
            return sortOptions[row]
        }
        else {
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == windowPicker {
            let selectedWindow = windowOptions[row]
            self.windowTextField.text = selectedWindow
        }
        else if pickerView == sortPicker {
            let selectedSort = sortOptions[row]
            self.sortTextField.text = selectedSort
        }
    }
    
}

























