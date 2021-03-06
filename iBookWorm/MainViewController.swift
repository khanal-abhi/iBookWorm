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
    var currentBook:Book?;
    
    let bookDetailSegueIdentifier = "BookDetailSegue";
    let detailViewControllerIdentifier = "DetailViewController";
    let addBookViewCOntrollerIdentifier = "AddBookViewController";
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let context:NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
        bookService = BookService(context: context);
        
        // Async check for first run / file load
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)){
            self.checkForFirstRun();
        }
        
        // Set up the default back button
        self.navigationItem.leftItemsSupplementBackButton = true;
        
        // Set up the title for the navigation bar
        self.navigationItem.title = "iBookWorm";
        
        // Set up the title for table view
//        self.tableView.h
        
        
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
        
        self.currentBook = books[indexPath.row];
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier(detailViewControllerIdentifier) as! DetailViewController;
        
        detailViewController.book = currentBook;
        self.navigationController?.pushViewController(detailViewController, animated: true);
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadBooksFromDatabase();
    }
    
    func checkForFirstRun(){
        let preferences = NSUserDefaults.standardUserDefaults();
        
        if let _ = preferences.objectForKey(keyForHasBeenRunBefore) {
            // Has been run before
            self.loadBooksFromDatabase();
            
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
        bookService?.commit();
        
        // use main thread to load the data to the table view
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData();
        }
        
    }
    
    func loadBooksFromDatabase(){
        if let books = bookService?.getAll() {
            self.books = books;
            
            // use main thread to load the data to the table view
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData();
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let book = self.books[indexPath.row];
        
        if editingStyle == .Delete {
            // Remove from the array (for instant view change)
            self.books.removeAtIndex(indexPath.row);
            
            // Remove from the database (for persistence)
            
            self.bookService?.delete(book);
                        
            // Remove with animation (for aesthetics)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade);
            
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)){
                self.bookService?.commit();
            }
            
        } else if editingStyle == .Insert {
            let addBookViewController = self.storyboard?.instantiateViewControllerWithIdentifier(self.addBookViewCOntrollerIdentifier) as! AddBookViewController;
            
            self.navigationController?.pushViewController(addBookViewController, animated: true);
        }
    }
    
    @IBAction func addBookClicked(sender: AnyObject) {
        
        let addBookViewController = self.storyboard?.instantiateViewControllerWithIdentifier(self.addBookViewCOntrollerIdentifier) as! AddBookViewController;
        
        self.navigationController?.pushViewController(addBookViewController, animated: true);
    }
}
