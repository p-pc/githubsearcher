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
    
    var repoURLStrVal : String = ""
    
    var userDetails = UserDetailsModel()
    
    var results = [RepoDetailsModel]() {
        didSet {
            searchResults = results
        }
    }
    
    var searchResults = [RepoDetailsModel]()
    
    var objects = [Any]()

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
    
    func refreshDataForRepoList() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            self.refreshRepoList()
        }
    }
    
    func refreshRepoList() {
        
        if !Reachability.forInternetConnection().isReachable() {
            
            let alert = UIAlertController(title: "", message: "Please connect to internet", preferredStyle: UIAlertController.Style.alert)
            
            let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(alertActionOK)
            
            DispatchQueue.main.async {
                
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            
        }
        
        ServiceManager.sharedInstance.getRepoListsFor(repoURLStr: repoURLStrVal, completion: { error,response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            func onSuccess(response: [RepoDetailsModel]) {
                
                DispatchQueue.main.async {
                    
                    self.results = response
                    self.refreshDataForRepoList()
                    
                }
            }
            
            func onFailure(error: Error) {
                
                self.results = [RepoDetailsModel]()
                
                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(alertActionOK)
                
                DispatchQueue.main.async {
                    
                    self.refreshDataForRepoList()
                    
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

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ReposTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReposTableViewCell", for: indexPath) as! ReposTableViewCell
        
        let resultItem = searchResults[indexPath.row]
        
        cell.repoNameLabel!.text = ""
        cell.forksLabel!.text = ""
        cell.starsLabel!.text = ""
        
        if let repoNameLabelStr = resultItem.repoName {
            cell.repoNameLabel!.text = repoNameLabelStr
        }
        
        cell.forksLabel!.text = "\(resultItem.forks) Forks"
        
        cell.starsLabel!.text = "\(resultItem.stars) Stars"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}
