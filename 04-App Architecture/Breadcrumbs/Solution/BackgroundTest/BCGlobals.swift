//
//  BCGlobals.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 04/12/2015.
//  Copyright © 2015 Plymouth University. All rights reserved.
//

import Foundation
let pathToDocumentsFolder : String = {
   let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
   return paths[0]
}()

let pathToFileInDocumentsFolder = { (fileName : String) -> String in
   return (pathToDocumentsFolder as NSString).appendingPathComponent(fileName)
}
