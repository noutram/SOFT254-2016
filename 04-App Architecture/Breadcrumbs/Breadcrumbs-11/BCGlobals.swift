//
//  BCGlobals.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 25/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import Foundation

let pathToDocumentsFolder : String = {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    return paths[0]
}()

let pathToFileInDocumentsFolder = { (fileName : String) -> String in
    return (pathToDocumentsFolder as NSString).appendingPathComponent(fileName)
}
