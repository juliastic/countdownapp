//
//  AddViewController.swift
//  Count Down
//
//  Created by Julia Grill on 27/02/2015.
//  Copyright (c) 2015 Julia Grill. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var countdownDate: UIDatePicker!
    @IBOutlet weak var countdownName: UITextView!
    
    var managedObjectContext: NSManagedObjectContext?
    var countdownModel: CountDownModelProtocol?
    var contentVC: ContentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "New Countdown"
        
        countdownDate.minimumDate = NSDate().dateByAddingTimeInterval(120)
        countdownName.delegate = self
        countdownName.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
    
    func saveCountdown() {
        var dateCreated = NSDate()
        
        if countElements(countdownName.text) > 0 {
            // create & schedule notification
            var countdownNotification = UILocalNotification()
            countdownNotification.fireDate = countdownDate.date
            countdownNotification.alertBody = "Your countdown \(countdownName.text!) is finished!"
            countdownNotification.applicationIconBadgeNumber = 0
            countdownNotification.timeZone = NSTimeZone.defaultTimeZone()
            UIApplication.sharedApplication().scheduleLocalNotification(countdownNotification)
            
            // store countdown data in model
            CoredownModel.storeCountdownDataInManagedObjectContext(managedObjectContext!, notification: countdownNotification, eventName: countdownName.text, dateCreated: dateCreated)
            performSegueWithIdentifier("showTableView", sender: self)
        } else {
            var countdownOverAlert = UIAlertController(title: NSLocalizedString("No Event Name", comment: "Alert title when user doesnt enter an event name."), message: NSLocalizedString("Please add an event name.", comment: "Alert message when user doesn't enter an event name."), preferredStyle: UIAlertControllerStyle.Alert)
            countdownOverAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(countdownOverAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: UIViewController
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        saveCountdown()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTableView" {
            let navigationController = segue.destinationViewController as UINavigationController
            var destinationController = navigationController.topViewController as CountdownTableViewController
            destinationController.managedObjectContext = managedObjectContext
        }
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if segue.identifier == "dismissView" {
//            var destinationVC = segue.destinationViewController as ViewController
//            destinationVC.managedObjectContext = managedObjectContext
//        }
//    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldReceiveTouch touch: UITouch!) -> Bool {
        let touchedView = touch.view
        if touchedView != countdownName.text {
            countdownName.endEditing(true)
        }
        return true
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        countdownName.endEditing(true) // hides keyboard when hitting return
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
