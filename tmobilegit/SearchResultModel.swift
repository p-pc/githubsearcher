//
//  SearchResultModel.swift
//  tmobilegit
//
//  Created by Parthiban on 9/5/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit

class SearchResultModel: NSObject, NSCoding {
    
    var username : String?
    
    var iconURL : String?
    
    var repoURL : String?
    
    var repoCount : Int = 0
    
    override init() {
        
    }
    
    required convenience init?(jsonData : Dictionary<String,AnyObject>){
        
        self.init()
        
        dLog("jsonData : \(jsonData)")
        
        if let usernameStr = jsonData["login"] as? String {
            self.username = usernameStr
        }
        
        if let iconURLStr = jsonData["avatar_url"] as? String {
            self.iconURL = iconURLStr
        }
        
        if let repoURLStr = jsonData["repos_url"] as? String {
            self.repoURL = repoURLStr
        }
        
        //get repo count here
        
    }
    
    
    required convenience init?(coder decoder: NSCoder){
        self.init()
        self.username = decoder.decodeObject(forKey: "username") as! String?
        self.iconURL = decoder.decodeObject(forKey: "iconURL") as! String?
        self.repoURL = decoder.decodeObject(forKey: "repoURL") as! String?
        self.repoCount = decoder.decodeObject(forKey: "repoCount") as! Int
    }
    
    func encode(with coder: NSCoder){
        coder.encode(self.username, forKey: "username")
        coder.encode(self.iconURL, forKey: "iconURL")
        coder.encode(self.repoURL, forKey: "repoURL")
        coder.encode(self.repoCount, forKey: "repoCount")
    }
    
}
