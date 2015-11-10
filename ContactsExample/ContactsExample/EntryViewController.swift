//
//  EntryViewController.swift
//  Contacts
//
//  Created by Marco Bonato on 10/11/15.
//  Copyright © 2015 Vooice. All rights reserved.
//

import UIKit
import ContactsUI

enum EntryViewController_Status {
    case Add
    case Modify
}

protocol HomePageDelegate{
    func addContact(entry:Entry)
    func modifyContact(entry:Entry)
}

class EntryViewController: UIViewController, UITextFieldDelegate, CNContactPickerDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    var status:EntryViewController_Status! // to fill
    var entry:Entry! // to fill
    
    private var changes:Bool = false
    
    var delegate:HomePageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        surnameField.delegate = self
        phoneField.delegate = self

        // change title depending if we're adding or modifying an entry
        if status == .Add{
            self.navigationItem.title = "Add new entry"
        }else if status == .Modify{
            self.navigationItem.title = "Edit entry"
            navigationItem.rightBarButtonItem = nil
            nameField.text = entry.name
            surnameField.text = entry.surname
            phoneField.text = entry.phone_number
        }
        
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func prefersStatusBarHidden() -> Bool { return false }
    override func preferredStatusBarStyle() -> UIStatusBarStyle{ return UIStatusBarStyle.LightContent }
    override func shouldAutorotate() -> Bool { return true }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    //////////////////////////////
    // Text field delegate
    
    func textFieldDidBeginEditing(textField: UITextField){
        changes = true
        print(changes)
    }
    
    
    //////////////////////////////
    // Name, suraname, phone number validation

    private func validate() -> Bool{
        if nameField.text?.isEmpty == true || surnameField.text?.isEmpty == true || phoneField.text?.isEmpty == true{
            self.showAlert("A field is empty.")
            print("A field is empty.")
            return false
        }
        
        // Phone number validation
        if let text = phoneField.text{
            let array = text.componentsSeparatedByString(" ")

            // Phone number is not well separated or is incomplete
            if array.count != 3{
                self.showAlert("The phone number is incomplete.")
                print("The phone number is incomplete.")
                return false
            }
            
            // Prefix contain 1 charater
            if array[0].characters.count < 2{
                self.showAlert("Invalid prefix.")
                print("Invalid prefix (0).")
                return false
            }
            
            // Prefix don't start with character +
            if text.characters.first != "+"{
                self.showAlert("Invalid prefix.")
                print("Invalid prefix (1).")
                return false
            }
            
            // The remain part of the prefix (except the +) is not a digit
            if Int((array[0] as NSString).substringFromIndex(1)) == nil{
                self.showAlert("Invalid prefix.")
                print("Invalid prefix (2).")
                return false
            }

            // The second part of the phone number is not a digit
            if Int(array[1]) == nil{
                self.showAlert("Invalid phone number.")
                print("Invalid phone number (0).")
                return false
            }
            
            // The third part of the phone number contain less than 6 character
            if array[2].characters.count < 6{
                self.showAlert("Invalid phone number.")
                print("Invalid phone number (1).")
                return false
            }
            
            // The third part of the phone number is not a digit
            if Int(array[2]) == nil{
                self.showAlert("Invalid phone number.")
                print("Invalid phone number (2).")
                return false
            }
        }
        return true
    }
    
    
    //////////////////////////////
    // Import entry from contacts - (navigation right button)
    
    @IBAction func importAction(sender: AnyObject) {
        getContact()
    }
    
    private func getContact(){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }

    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        var phone_string:String = ""
        if (contact.isKeyAvailable(CNContactPhoneNumbersKey)) {
            for phoneNumber:CNLabeledValue in contact.phoneNumbers {
                let value = phoneNumber.value as! CNPhoneNumber
                phone_string = value.stringValue
            }
        }
        let entry = Entry(name: contact.givenName, surname: contact.familyName, phone_number: phone_string)
        self.delegate?.addContact(entry)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    //////////////////////////////
    // Close add/edit page - (navigation left button)
    
    @IBAction func doneAction(sender: AnyObject) {
        if changes == true && self.validate() == false{
            print("Insered value are not correct.")
            return;
        }else if changes == true{
            if status == .Add{
                self.entry = Entry(name: nameField.text!, surname: surnameField.text!, phone_number: phoneField.text!)
                self.delegate?.addContact(entry)
            }else{
                self.entry = Entry(name: nameField.text!, surname: surnameField.text!, phone_number: phoneField.text!)
                self.delegate?.modifyContact(entry)
            }
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    
    //////////////////////////////
    // Alert
    
    func showAlert(message:String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in print("") }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true){}
    }

    
}
