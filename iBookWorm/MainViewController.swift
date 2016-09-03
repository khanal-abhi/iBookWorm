//
//  MainViewController.swift
//  iBookWorm
//
//  Created by Abhinash Khanal on 9/2/16.
//  Copyright © 2016 KHANALCO. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var books: [Book] = [];
    let cellIdentifier = "BookViewCell";
    
    override func viewDidLoad() {
        super.viewDidLoad();
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
}
