//
//  SearchResultModel.swift
//  tmobilegit
//
//  Created by Parthiban on 9/5/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit

class SearchResultModel: NSObject, NSCoding {
    
    var firstURL : String?
    
    var iconURL : String?
    
    var resultHTML : String?
    
    var text : String?
    
    var title : String?
    
    override init() {
        
    }
    
    required convenience init?(jsonData : Dictionary<String,AnyObject>){
        
        self.init()
        
        dLog("jsonData : \(jsonData)")
        
        if let textStr = jsonData["Text"] as? String {
            self.text = textStr
            
            //comment - this is just an ugly coding for time's sake - better parsing of html is possible
            let textArr = textStr.components(separatedBy: " -")
            
            if textArr.first != nil {
                self.title = textArr.first
            }
            
        }
        
        if let resultStr = jsonData["Result"] as? String {
            self.resultHTML = resultStr
        }
        
        if let firstURLStr = jsonData["FirstURL"] as? String {
            self.firstURL = firstURLStr
        }
        
        if let imgURLStr = jsonData["Icon"]!["URL"] as? String {
            self.iconURL = imgURLStr
        }
        
    }
    
    
    required convenience init?(coder decoder: NSCoder){
        self.init()
        self.firstURL = decoder.decodeObject(forKey: "firstURL") as! String?
        self.iconURL = decoder.decodeObject(forKey: "iconURL") as! String?
        self.resultHTML = decoder.decodeObject(forKey: "resultHTML") as! String?
        self.text = decoder.decodeObject(forKey: "text") as! String?
        self.title = decoder.decodeObject(forKey: "title") as! String?
    }
    
    func encode(with coder: NSCoder){
        coder.encode(self.firstURL, forKey: "firstURL")
        coder.encode(self.iconURL, forKey: "iconURL")
        coder.encode(self.resultHTML, forKey: "resultHTML")
        coder.encode(self.text, forKey: "text")
        coder.encode(self.title, forKey: "title")
    }
    
}
