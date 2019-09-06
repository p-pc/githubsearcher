//
//  Utility.swift
//  tmobilegit
//
//  Created by Parthiban on 9/5/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit
import Kingfisher

class Utility: NSObject {
    
    public var userMediaCache =  ImageCache(name: "UserMedia")
    
    static let sharedInstance: Utility = {
        
        let instance = Utility()
        
        return instance
        
    }()
    
    class func parseResultsFrom(jsonDict : NSDictionary) -> [SearchResultModel] {
        
        var resultArr = [SearchResultModel]()
        
        guard let resArrDict = jsonDict["items"] as? [Any] else {return resultArr}
        
        for aDict in resArrDict {
            
            guard let aDictVal = aDict as? Dictionary<String,AnyObject> else {continue}
            
            guard let aModel = SearchResultModel(jsonData: aDictVal) else {continue}
            
            resultArr.append(aModel)
        }
        
        return resultArr
        
    }
    
    class func getStringFor(key:String) -> String? {
        
        guard let path = Bundle.main.path(forResource: "Environment", ofType: "plist") else {return nil}
        
        guard let dict = NSDictionary(contentsOfFile: path) else {return nil}
        
        if let strVal = dict.value(forKey: key) as? String {
            return strVal
        }else{
            return nil
        }
        
    }
    
    class func searchURLFor(text : String) -> URL? {
        
        guard let urlStr = Utility.getStringFor(key: "SearchURL") else {return nil}
        
        let strVal = String(format:urlStr, text)
        
        guard let urlVal = URL(string:strVal) else {return nil}
        
        return urlVal
        
    }
    
}

#if DEBUG
func dLog(_ message:  @autoclosure () -> String, filename: String = #file, function: String = #function, line: Int = #line) {
    NSLog("%@", message())
}
#else
func dLog(_ message:  @autoclosure () -> String, filename: String = #file, function: String = #function, line: Int = #line) {
}
#endif
