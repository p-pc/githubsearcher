//
//  DetailViewController.swift
//  tmobilegit
//
//  Created by Parthiban on 9/5/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var usernameStr : String = ""
    
    var userDetails = UserDetailsModel()
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        getUserFullDetails()
        
        //data setup
        self.usernameLabel.text = ""
        
        self.emailLabel.text = ""
    
        self.locationLabel.text = ""
    
        self.joinDateLabel.text = ""
    
        self.followersLabel.text = "0 Followers"
        
        self.followingLabel.text = "Following 0"
        
        self.bioTextView.text = ""
        
    }

    func getUserFullDetails() {
        
        if !Reachability.forInternetConnection().isReachable() {
            
            let alert = UIAlertController(title: "", message: "Please connect to internet", preferredStyle: UIAlertController.Style.alert)
            
            let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(alertActionOK)
            
            DispatchQueue.main.async {
                
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            
        }
        
        ServiceManager.sharedInstance.getUserDetailsFor(username: usernameStr, completion: { error,response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            func onSuccess(response: UserDetailsModel) {
                
                DispatchQueue.main.async {
                    
                    self.userDetails = response
                    self.refreshData()
                    
                }
            }
            
            func onFailure(error: Error) {
                
                self.userDetails = UserDetailsModel()
                
                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(alertActionOK)
                
                DispatchQueue.main.async {
                    
                    self.refreshData()
                    
                    //Comment : alert the user when something fails
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            if let err = error {
                
                onFailure(error: err)
                
            }
            else {
                
                guard let respData = response else {
                    
                    onFailure(error: NSError(domain:"", code:-1, userInfo:["localizedDescription":"Something went wrong"]))
                    
                    return
                }
                
                onSuccess(response: respData)
            }
            
        })
        
    }
    
    func refreshData() {
        DispatchQueue.main.async {
            //1. set all label values and load image in image view
            
            if let userNameStrVal = self.userDetails.username {
                self.usernameLabel.text = userNameStrVal
            }
            
            if let emailStrVal = self.userDetails.email {
                self.emailLabel.text = emailStrVal
            }
            
            if let locationStrVal = self.userDetails.location {
                self.locationLabel.text = locationStrVal
            }
            
            if let joinDateStrVal = self.userDetails.joinDate {
                self.joinDateLabel.text = joinDateStrVal
            }
            
            self.followersLabel.text = "\(self.userDetails.followers) Followers"
            
            self.followingLabel.text = "Following \(self.userDetails.following)"
            
            if let bioStrVal = self.userDetails.biography {
                self.bioTextView.text = bioStrVal
            }
            
            if let imageURL = self.userDetails.iconURL {
                
                let plcHldrImg = UIImage(named: "placeholder")
                
                if let builtUrl = URL.init(string: imageURL) {
                    
                    let resource = ImageResource(downloadURL: builtUrl, cacheKey: imageURL)
                    self.imageView.kf.setImage(with: resource, placeholder: plcHldrImg, options: [.targetCache(Utility.sharedInstance.userMediaCache),.cacheMemoryOnly], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                        
                        if let err = error {
                            dLog("error in downloading profile image : \(err)")
                            
                            DispatchQueue.main.async {
                                self.imageView.image = UIImage(named: "placeholder")
                            }
                        }
                        else {
                            
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                            
                            
                        }
                        
                        
                    })
                }
                
            }
            //2. fetch repos and reload - self.tableView.reloadData()
        }
    }
    
    var detailItem: NSDate? {
        didSet {
            configureView()
        }
    }

}

// MARK: - UISearchBarDelegate

extension DetailViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    
}

