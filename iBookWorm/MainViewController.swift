//
//  MainViewController.swift
//  iBookWorm
//
//  Created by Abhinash Khanal on 9/2/16.
//  Copyright © 2016 KHANALCO. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    let keyForHasBeenRunBefore = "hasBeenRunBefore";
    let cellIdentifier = "BookViewCell";
    var books: [Book] = [];
    var bookService:BookService?;
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        var context:NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
        bookService = BookService(context: context);
        // Read Json File to make sure it is working
        self.loadBooksFromJsonFile();
        
        // Check the books count in the database. If > 0 no need to load from
        self.checkForFirstRun();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let placeHolderCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier);
        
        if let cell = placeHolderCell {
            let book = books[indexPath.row];
            cell.textLabel?.text = book.title;
            cell.detailTextLabel?.text = book.author;
            return cell;
        } else {
            return UITableViewCell();
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func checkForFirstRun(){
        let preferences = NSUserDefaults.standardUserDefaults();
        
        if let _ = preferences.objectForKey(keyForHasBeenRunBefore) {
            // Has been run before
            
        } else {
            // Has not been run before
            // Load the books from file
            self.loadBooksFromJsonFile();
            
            // Set the preference so that this will not be executed again!
            preferences.setBool(true, forKey: keyForHasBeenRunBefore);
            preferences.synchronize();
            
            
        }
    }
    
    func readJsonFile() -> String? {
        if let path = NSBundle.mainBundle().pathForResource("books", ofType: "json"){
            do {
                let jsonString = try String(contentsOfFile: path);
                return jsonString;
            } catch let error as NSError {
                print(error);
                return nil;
            }
        }
        return nil;
    }
    
    func loadBooksFromJsonFile(){
        var bookHolders:[BookHolder] = [];
        
        if let jsonStringBooks = self.readJsonFile() {
            let jsonNSStringBooks = NSString(string: jsonStringBooks);
            if let jsonDataBooks = jsonNSStringBooks.dataUsingEncoding(NSUTF8StringEncoding) {
                if let jsonArray:AnyObject? = try? NSJSONSerialization.JSONObjectWithData(jsonDataBooks, options: NSJSONReadingOptions(rawValue: 0)) {
                    if jsonArray is Array<AnyObject> {
                        for jsonBook in jsonArray as! Array<AnyObject> {
                            bookHolders.append(BookService.jsonBookToBookHolder(jsonBook));
                        }
                    } else {
                        // json file is not an array at root
                    }
                } else {
                    // Could not parse json from data
                }
            } else {
                // Could not convert jsonNSStringBooks to jsonDataBooks
            }
        }
        
        self.insertLoadedBooks(bookHolders);
    }
    
    func insertLoadedBooks(bookHolders:[BookHolder]) {
        for bookHolder in bookHolders {
            books.append((bookService?.insert(bookHolder.title, author: bookHolder.author, genre: bookHolder.genre, year: bookHolder.year))!);
        }
        tableView.reloadData();
        
    }
}