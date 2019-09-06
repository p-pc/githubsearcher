//
//  MasterViewController.swift
//  tmobilegit
//
//  Created by Parthiban on 9/5/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit
import Kingfisher

class MasterViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var masterTableView: UITableView!
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    var results = [SearchResultModel]() {
        didSet {
            searchResults = results
        }
    }
    
    var searchResults = [SearchResultModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(MasterViewController.appCameToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }
    
    @objc func appCameToForeground(){
        clearResults()
    }

    func clearResults() {
        //clear the table and data
        DispatchQueue.main.async {
            self.results = [SearchResultModel]()
            self.refreshData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func getUsersFor(string : String) {
        
        if !Reachability.forInternetConnection().isReachable() {
            
            let alert = UIAlertController(title: "", message: "Please connect to internet", preferredStyle: UIAlertController.Style.alert)
            
            let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(alertActionOK)
            
            DispatchQueue.main.async {
                
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            
        }
        
        let searchText = string
        
        ServiceManager.sharedInstance.getResultsFor(searchText: searchText, completion: { error,response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            func onSuccess(response: [SearchResultModel]) {
                
                DispatchQueue.main.async {
                
                    self.results = response
                    self.refreshData()
                    
                }
            }
            
            func onFailure(error: Error) {
                
                self.results = [SearchResultModel]()
                
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
            self.masterTableView.reloadData()
        }
    }

}

// MARK: - UISearchBarDelegate

extension MasterViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        
        

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            clearResults()
            return
        }
        
        if searchText.count >= 3 {
            //search
            getUsersFor(string:searchText)
        }
        else {
            //clear table & results model
            clearResults()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MasterViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        let resultItem = searchResults[indexPath.row]
        
        cell.usernameLabel!.text = ""
        cell.repoCountLabel!.text = ""
        
        if let titlelbl = resultItem.username {
            cell.usernameLabel!.text = titlelbl
        }
        
        cell.repoCountLabel.text = "Repos: \(resultItem.repoCount)"
        
        if let imageURL = resultItem.iconURL {
            
            let plcHldrImg = UIImage(named: "placeholder")
            
            if let builtUrl = URL.init(string: imageURL) {
                
                let resource = ImageResource(downloadURL: builtUrl, cacheKey: imageURL)
                cell.avatarImageView.kf.setImage(with: resource, placeholder: plcHldrImg, options: [.targetCache(Utility.sharedInstance.userMediaCache),.cacheMemoryOnly], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    
                    if let err = error {
                        dLog("error in downloading profile image : \(err)")
                        
                        DispatchQueue.main.async {
                            cell.avatarImageView.image = UIImage(named: "placeholder")
                        }
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            cell.avatarImageView.image = image
                        }
                        
                        
                    }
                    
                    
                })
            }
            
        }
        
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
