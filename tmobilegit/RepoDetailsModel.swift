//
//  RepoDetailsModel.swift
//  tmobilegit
//
//  Created by Parthiban on 9/6/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit

class RepoDetailsModel: NSObject, NSCoding {
    
    var repoName : String?
    
    var forks : Int = 0
    
    var stars : Int = 0
    
    var repoLink : String?
    
    override init() {
        
    }
    
    required convenience init?(jsonData : Dictionary<String,AnyObject>){
        
        self.init()
        
//        dLog("jsonData : \(jsonData)")
        
        if let repoNameStr = jsonData["name"] as? String {
            self.repoName = repoNameStr
        }
        
        if let forksCount = jsonData["forks_count"] as? Int {
            self.forks = forksCount
        }
        
        if let starsCount = jsonData["stargazers_count"] as? Int {
            self.stars = starsCount
        }
        
        if let repoLinkStr = jsonData["html_url"] as? String {
            self.repoLink = repoLinkStr
        }
        
        //get repo count here
        
    }
    
    
    required convenience init?(coder decoder: NSCoder){
        self.init()
        self.repoName = decoder.decodeObject(forKey: "repoName") as! String?
        self.forks = decoder.decodeObject(forKey: "forks") as! Int
        self.stars = decoder.decodeObject(forKey: "stars") as! Int
        self.repoLink = decoder.decodeObject(forKey: "repoLink") as! String?
    }
    
    func encode(with coder: NSCoder){
        coder.encode(self.repoName, forKey: "repoName")
        coder.encode(self.forks, forKey: "forks")
        coder.encode(self.stars, forKey: "stars")
        coder.encode(self.repoLink, forKey: "repoLink")
    }
    
}
