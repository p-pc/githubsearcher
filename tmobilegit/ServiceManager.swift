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
        
        Alamofire.request(url).responseJSON(completionHandler: { response in
            
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
    
}
