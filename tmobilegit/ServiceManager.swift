//
//  ServiceManager.swift
//  tmobilegit
//
//  Created by Parthiban on 9/5/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit
import Alamofire

class ServiceManager: NSObject {
    
    static let sharedInstance: ServiceManager = {
        
        let instance = ServiceManager()
        
        return instance
        
    }()
    
    func getResultsFor(searchText : String, completion:@escaping (Error?, [SearchResultModel]?) ->Void) {
        
        var err:Error?
        
        guard let url = Utility.searchURLFor(text: searchText) else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid URL"])
            
            completion(err,nil)
            
            return
            
        }
        
        guard let base64Credentials =  Utility.getAuthCreds() else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Auth Error"])
            
            completion(err,nil)
            
            return

        }
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).validate().responseJSON(completionHandler: { response in
            
            switch response.result {
                
            case .success:
                
                guard response.data != nil else {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid Data"])
                    
                    completion(err,nil)
                    
                    return
                    
                }
                
                do {
                    guard let parsedObject : NSDictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary else {
                        
                        err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid JSON Data"])
                        
                        completion(err,nil)
                        
                        return
                        
                    }
                    
                    let modelArr = Utility.parseResultsFrom(jsonDict: parsedObject)
                    
                    completion(nil, modelArr)
                    
                }
                catch {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid JSON"])
                    
                    completion(err,nil)
                    
                }
                
            case .failure(let errVal):
                
                err = NSError(domain:"", code:-1, userInfo:["localizedDescription":errVal.localizedDescription])
                
                completion(errVal,nil)
            }
            
        })
        
    }
    
    func getUserDetailsFor(username : String, completion:@escaping (Error?, UserDetailsModel?) ->Void) {
        
        var err:Error?
        
        guard let url = Utility.detailsURLFor(username: username) else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid URL"])
            
            completion(err,nil)
            
            return
            
        }
        
        guard let base64Credentials =  Utility.getAuthCreds() else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Auth Error"])
            
            completion(err,nil)
            
            return
            
        }
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).validate().responseJSON(completionHandler: { response in
            
            switch response.result {
                
            case .success:
                
                guard response.data != nil else {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid Data"])
                    
                    completion(err,nil)
                    
                    return
                    
                }
                
                do {
                    guard let parsedObject : NSDictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary else {
                        
                        err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid JSON Data"])
                        
                        completion(err,nil)
                        
                        return
                        
                    }
                    
                    let userDetailsModel = Utility.parseUserDetailsFrom(jsonDict: parsedObject)
                    
                    completion(nil, userDetailsModel)
                    
                }
                catch {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid JSON"])
                    
                    completion(err,nil)
                    
                }
                
            case .failure(let errVal):
                
                err = NSError(domain:"", code:-1, userInfo:["localizedDescription":errVal.localizedDescription])
                
                completion(errVal,nil)
            }
            
        })
        
    }
    
    func getRepoCountFor(repoURLStr : String, completion:@escaping (Error?, Int) ->Void) {
        
        var err:Error?
        
        guard let url = URL(string:repoURLStr) else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid URL"])
            
            completion(err,0)

            return
            
        }
        
        guard let base64Credentials =  Utility.getAuthCreds() else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Auth Error"])
            
            completion(err,0)
            
            return
            
        }

        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).validate().responseJSON(completionHandler: { response in
            
            switch response.result {
                
            case .success:
                
                guard response.data != nil else {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid Data"])
                    
                    completion(err,0)
                    
                    return
                    
                }
                
                do {
                    
//                    let parsedData = try JSONSerialization.jsonObject(with: response.data!) as! [[String:Any]]
                    
                    guard let parsedData : [[String:Any]] = try JSONSerialization.jsonObject(with: response.data!) as? [[String:Any]] else {
                        
                        err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid JSON Data"])
                        
                        completion(err,0)
                        
                        return
                        
                    }
                    
                    dLog("parsedData : \(parsedData.count)")
                    
                    let modelArrCount = parsedData.count
                    
                    completion(nil, modelArrCount)
                    
                } catch let error as NSError {
                    
                    dLog("JSONSerialization parsing error : \(error)")
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid JSON"])
                    
                    completion(err,0)
                    
                }

            case .failure(let errVal):
                
                err = NSError(domain:"", code:-1, userInfo:["localizedDescription":errVal.localizedDescription])
                
                completion(errVal,0)
            }
            
        })
        
    }
    
    func getRepoListsFor(repoURLStr : String, completion:@escaping (Error?, [RepoDetailsModel]?) ->Void) {
        
        var err:Error?
        
        guard let url = URL(string:repoURLStr) else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid URL"])
            
            completion(err,nil)
            
            return
            
        }
        
        guard let base64Credentials =  Utility.getAuthCreds() else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Auth Error"])
            
            completion(err,nil)
            
            return
            
        }
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).validate().responseJSON(completionHandler: { response in
            
            switch response.result {
                
            case .success:
                
                guard response.data != nil else {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid Data"])
                    
                    completion(err,nil)
                    
                    return
                    
                }
                
                do {
                    
                    guard let parsedData : [[String:Any]] = try JSONSerialization.jsonObject(with: response.data!) as? [[String:Any]] else {
                        
                        err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid JSON Data"])
                        
                        completion(err,nil)
                        
                        return
                        
                    }
                    
                    let modelArr = Utility.parseRepoListsFrom(jsonDict: parsedData)
                    
                    completion(nil, modelArr)
                    
                }
                catch {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid JSON"])
                    
                    completion(err,nil)
                    
                }
                
            case .failure(let errVal):
                
                err = NSError(domain:"", code:-1, userInfo:["localizedDescription":errVal.localizedDescription])
                
                completion(errVal,nil)
            }
            
        })
        
    }
    
}
