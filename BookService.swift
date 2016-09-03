//
//  BookService.swift
//  iBookWorm
//
//  Created by Abhinash Khanal on 9/2/16.
//  Copyright © 2016 KHANALCO. All rights reserved.
//

import Foundation
import CoreData

class BookService {
    
    var context:NSManagedObjectContext;
    
    init(context:NSManagedObjectContext){
        self.context = context;
    }
    
    func insert(title:String, author:String, genre:String, year:Int) -> Book {
        let book = NSEntityDescription.insertNewObjectForEntityForName(Book.entityName, inManagedObjectContext: context) as! Book;
        book.title = title;
        book.author = author;
        book.genre = genre;
        book.year = year;
        
        return book;
    }
    
    func getById(id:NSManagedObjectID) -> Book? {
        do {
            let book = try context.existingObjectWithID(id) as! Book;
            return book;
        } catch let error as NSError {
            print(error);
            return nil;
        }
    }
    
    func get(withPredicate queryPredicate:NSPredicate) -> [Book] {
        let fetchRequest = NSFetchRequest(entityName: Book.entityName);
        fetchRequest.predicate = queryPredicate;
        do {
            let result = try context.executeFetchRequest(fetchRequest) as! [Book];
            return result;
        } catch let error as NSError {
            print(error);
            return [];
        }
    }
    
    func getAll() -> [Book] {
        return self.get(withPredicate: NSPredicate(value: true));
    }
    
    func update(book:Book) -> Book? {
        if let updatedBook = self.getById(book.objectID) {
            updatedBook.title = book.title;
            updatedBook.author = book.author;
            updatedBook.genre = book.genre;
            updatedBook.year = book.year;
            
            return updatedBook;
        }
        return nil;
    }
    
    func delete(book:Book) -> Bool {
        if let bookToBeDeleted = self.getById(book.objectID) {
            context.deleteObject(bookToBeDeleted);
            return true;
        }
        
        return false;
    }
    
    func commit(){
        do {
            try context.save();
        } catch let error as NSError {
            print(error);
        }
    }
    
    static func jsonBookToBookHolder(jsonBook:AnyObject) -> BookHolder {
        let title = jsonBook["title"]as! String;
        let author = jsonBook["author"] as! String;
        let genre = jsonBook["genre"] as! String;
        let year = jsonBook["year"] as! Int;
        return BookHolder(id: NSManagedObjectID(), title: title, author: author, genre: genre, year: year);
    }
    
    static func bookToBookHolder(book:Book) -> BookHolder {
        return BookHolder(id: book.objectID, title: book.title!, author: book.author!, genre: book.genre!, year: Int(book.year!));
    }

}
