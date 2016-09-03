//
//  Book.swift
//  iBookWorm
//
//  Created by Abhinash Khanal on 9/2/16.
//  Copyright © 2016 KHANALCO. All rights reserved.
//

import Foundation
import CoreData


class Book: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static let entityName = "Book";

}

struct BookHolder {
    var id:NSManagedObjectID;
    var title:String;
    var author:String;
    var genre:String;
    var year:Int;
}
