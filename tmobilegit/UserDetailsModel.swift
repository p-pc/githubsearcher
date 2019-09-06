//
//  UserDetailsModel.swift
//  tmobilegit
//
//  Created by Parthiban on 9/6/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit

class UserDetailsModel: NSObject, NSCoding {
    
    var username : String?
    
    var email : String?
    
    var location : String?
    
    var joinDate : String?
    
    var followers : Int = 0
    
    var following : Int = 0
    
    var biography : String?

    var iconURL : String?

    var repoURL : String?
    
    override init() {
        
    }
    
    required convenience init?(jsonData : Dictionary<String,AnyObject>){
        
        self.init()
        
//        dLog("jsonData : \(jsonData)")
        
        if let usernameStr = jsonData["login"] as? String {
            self.username = usernameStr
        }
        
        if let emailStr = jsonData["email"] as? String {
            self.email = emailStr
        }
        
        if let locationStr = jsonData["location"] as? String {
            self.location = locationStr
        }
        
        if let joinDateStr = jsonData["created_at"] as? String {
            self.joinDate = joinDateStr
        }
        
        if let followersVal = jsonData["followers"] as? Int {
            self.followers = followersVal
        }
        
        if let followingVal = jsonData["following"] as? Int {
            self.following = followingVal
        }
        
        if let biographyStr = jsonData["bio"] as? String {
            self.biography = biographyStr
        }
        
        if let biographyStr = jsonData["bio"] as? String {
            self.biography = biographyStr
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
        self.email = decoder.decodeObject(forKey: "email") as! String?
        self.location = decoder.decodeObject(forKey: "location") as! String?
        self.joinDate = decoder.decodeObject(forKey: "joinDate") as! String?
        self.followers = decoder.decodeObject(forKey: "followers") as! Int
        self.following = decoder.decodeObject(forKey: "following") as! Int
        self.biography = decoder.decodeObject(forKey: "biography") as! String?
        self.iconURL = decoder.decodeObject(forKey: "iconURL") as! String?
        self.repoURL = decoder.decodeObject(forKey: "repoURL") as! String?
    }
    
    func encode(with coder: NSCoder){
        coder.encode(self.username, forKey: "username")
        coder.encode(self.email, forKey: "email")
        coder.encode(self.location, forKey: "location")
        coder.encode(self.joinDate, forKey: "joinDate")
        coder.encode(self.followers, forKey: "followers")
        coder.encode(self.following, forKey: "following")
        coder.encode(self.biography, forKey: "biography")
        coder.encode(self.iconURL, forKey: "iconURL")
        coder.encode(self.repoURL, forKey: "repoURL")

    }
    
}
