//
//  StructArchiver.swift
//  CCX Monitor
//
//  Created by Jason Goodney on 12/11/17.
//  Copyright © 2017 Jason Goodney. All rights reserved.
//

import Foundation

public protocol ArchivableStruct {
    var dataDictionary: [String: AnyObject] { get }
    init(dataDictionary aDict: [String: AnyObject])
}

public class StructArchiver<T: ArchivableStruct>: NSObject, NSCoding {

    var structValue: T
    
    public init(structValue: T) {
        self.structValue = structValue
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.structValue.dataDictionary, forKey: "dataDictionary")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        let dataDictionary = aDecoder.decodeObject(forKey: "dataDictionary") as! [String: AnyObject]
        self.structValue = T(dataDictionary: dataDictionary)
    }
    
    
}
