//
//  DetailViewController.swift
//  iBookWorm
//
//  Created by Abhinash Khanal on 9/3/16.
//  Copyright © 2016 KHANALCO. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var book:Book?;
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookGenre: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Update Book Details
        self.updateBookDetails();
    }
    
    func updateBookDetails() {
        
        if let currentBook = book {
            
            self.bookTitle.text = "Title: \(currentBook.title!)";
            self.bookAuthor.text = "Author: \(currentBook.author!)";
            self.bookGenre.text = "Genre: \(currentBook.genre!)";
            self.bookYear.text = "Year: \(currentBook.year!)";
        }
    }
    
}
