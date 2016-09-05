//
//  AddBookViewController.swift
//  iBookWorm
//
//  Created by Abhinash Khanal on 9/3/16.
//  Copyright © 2016 KHANALCO. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var bookAuthor: UITextField!
    @IBOutlet weak var bookGenre: UITextField!
    @IBOutlet weak var bookYear: UITextField!
   
    var validEntries:[String:Bool] = [:];
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Custom code here:
        
        // Initialize the validation check dictionary
        self.initializeValidationDictionary();
    }
    
    func textField(textField: UITextField, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        let length = NSString(string: text).length;
        
        if(textField == self.bookTitle){
            if length > 0 {
                textField.textColor = UIColor.greenColor();
                self.validEntries["title"] = true;
            } else {
                textField.textColor = UIColor.redColor();
                self.validEntries["title"] = false;
            }
            
        } else if (textField == self.bookAuthor) {
            if length > 0 {
                textField.textColor = UIColor.greenColor();
                self.validEntries["author"] = true;
            } else {
                textField.textColor = UIColor.redColor();
                self.validEntries["author"] = false;
            }
            
        } else if (textField == self.bookGenre) {
            if length > 0 {
                textField.textColor = UIColor.greenColor();
                self.validEntries["genre"] = true;
            } else {
                textField.textColor = UIColor.redColor();
                self.validEntries["genre"] = false;
            }
            
        } else if (textField == self.bookYear) {
            if length > 0 && length < 4 && Int(text)! <= 9999 {
                self.validEntries["year"] = true;
                textField.textColor = UIColor.greenColor();
            } else {
                textField.textColor = UIColor.redColor();
                self.validEntries["year"] = false;
            }
        }
        
        return true;
    }
    
    func setupTextViewDelegates(){
        self.bookTitle.delegate = self;
        self.bookAuthor.delegate = self;
        self.bookGenre.delegate = self;
        self.bookYear.delegate = self;
    }
    
    func initializeValidationDictionary() {
        self.validEntries = [String:Bool]();
        self.validEntries["title"] = false;
        self.validEntries["author"] = false;
        self.validEntries["genre"] = false;
        self.validEntries["year"] = false;
    }
    
    func validForSaving() -> Bool {
        var result = true;
        
        for (attribute , valid) in self.validEntries {
            
            if(!valid) {
                result = false;
                let okAction = UIAlertAction(title: "Invalid entry!", style: .Default, handler: {(action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil);
                });
                let alert = UIAlertView();
                alert.title = "Invalid Entry!";
                alert.message = "Please fix the error in \(attribute)";
                alert.addButtonWithTitle("Ok");
                
                return result;
            }
        }
        
        return result;
    }
    
    func setDelegates() {
        bookTitle.delegate = self;
        bookAuthor.delegate = self;
        bookGenre.delegate = self;
        bookYear.delegate = self;
    }
    
    @IBAction func saveClicked(sender: AnyObject) {
        self.validForSaving();

    }
}
