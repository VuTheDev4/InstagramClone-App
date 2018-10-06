//
//  UserTableViewController.swift
//  InstagramClone
//
//  Created by Vu Duong on 10/5/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSegue", for: indexPath)

        cell.textLabel?.text = "Test"

        return cell
    }

    @IBAction func logoutUser(_ sender: Any) {
        
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
        
        
    }
    
}
