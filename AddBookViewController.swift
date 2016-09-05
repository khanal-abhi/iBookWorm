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
        self.setDelegates();
    }

    func validateTextField(textField:UITextField) throws {
        
        guard let text = textField.text else {
            throw NSError(domain: "Nil textfield error!", code: -1, userInfo: nil);
        }
        
        let trimmedString = NSString(string: text).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "));
        
        let length = NSString(string: trimmedString).length;
        
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
            guard let _ = Int(text) else {
                self.validEntries["year"] = false;
                return;
            }
            
            let sweetLength = length > 0 && length < 5;
            
            if sweetLength {
                self.validEntries["year"] = true;
                textField.textColor = UIColor.greenColor();
            } else {
                textField.textColor = UIColor.redColor();
                self.validEntries["year"] = false;
            }
        }

        
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
        
        do {
            try self.validateTextField(self.bookTitle);
            try self.validateTextField(self.bookAuthor);
            try self.validateTextField(self.bookGenre);
            try self.validateTextField(self.bookYear);
            
        } catch let error as NSError {
            print(error);
        }
        
        
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
                alert.show();
                
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return self.validForSaving();
    }
    
    @IBAction func saveClicked(sender: AnyObject) {
        
        self.validForSaving();

    }
}
