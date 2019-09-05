//
//  MasterViewController.swift
//  tmobilegit
//
//  Created by Parthiban on 9/5/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

