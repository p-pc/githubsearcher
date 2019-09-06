//
//  UserTableViewCell.swift
//  tmobilegit
//
//  Created by Parthiban on 9/5/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var repoCountLabel: UILabel!
    
    var repoUrl: String?
    var repoCount: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getRepoCountAndUpdate() {
        guard let repoUrlStr = repoUrl else {return}
        
        if !Reachability.forInternetConnection().isReachable() {
            return
        }
        
        
        ServiceManager.sharedInstance.getRepoCountFor(repoURLStr: repoUrlStr, completion: { error,response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            func onSuccess(response: Int) {
                
                DispatchQueue.main.async {
                    
                    self.repoCount = response
                    self.repoCountLabel.text = "Repos: \(self.repoCount)"
                    
                }
            }
            
            func onFailure(error: Error) {
                //do nothing
            }
            
            if let err = error {
                
                onFailure(error: err)
                
            }
            else {
                
                onSuccess(response: response)
            }
            
        })
    }

}
