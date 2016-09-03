//
//  AddBookViewController.swift
//  iBookWorm
//
//  Created by Abhinash Khanal on 9/3/16.
//  Copyright © 2016 KHANALCO. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var bookTitle:UITextView!;
    @IBOutlet weak var bookAuthor:UITextView!;
    @IBOutlet weak var bookGenere:UITextView!;
    @IBOutlet weak var bookYear:UITextView!;
    
    var bookService:BookService?;
    var validEntries:[String:Bool] = [:];
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Custom code here:
        
        // Initialize the validation check dictionary
        self.initializeValidationDictionary();
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        let length = NSString(string: text).length;
        
        if(textView == self.bookTitle){
            if length > 0 {
                textView.textColor = UIColor.greenColor();
                self.validEntries["title"] = true;
            } else {
                textView.textColor = UIColor.redColor();
                self.validEntries["title"] = false;
            }
            
        } else if (textView == self.bookAuthor) {
            if length > 0 {
                textView.textColor = UIColor.greenColor();
                self.validEntries["author"] = true;
            } else {
                textView.textColor = UIColor.redColor();
                self.validEntries["author"] = false;
            }
            
        } else if (textView == self.bookGenere) {
            if length > 0 {
                textView.textColor = UIColor.greenColor();
                self.validEntries["genre"] = true;
            } else {
                textView.textColor = UIColor.redColor();
                self.validEntries["genre"] = false;
            }
            
        } else if (textView == self.bookYear) {
            if length > 0 && length < 4 && Int(text)! <= 9999 {
                self.validEntries["year"] = true;
                textView.textColor = UIColor.greenColor();
            } else {
                textView.textColor = UIColor.redColor();
                self.validEntries["year"] = false;
            }
        }
        
        return true;
    }
    
    func setupTextViewDelegates(){
        self.bookTitle.delegate = self;
        self.bookAuthor.delegate = self;
        self.bookGenere.delegate = self;
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
}
