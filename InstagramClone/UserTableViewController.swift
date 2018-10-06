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
    
    var usernames : [String] = []
    var objectIds : [String] = []
    var isFollowing : [String : Bool] = ["" : true]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSegue", for: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]
        
        if let followsBoolean = isFollowing[objectIds[indexPath.row]] {
            
            if followsBoolean {
                
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let followsBoolean = isFollowing[objectIds[indexPath.row]] {
            
            if followsBoolean {
                
                isFollowing[objectIds[indexPath.row]] = false
                
                cell?.accessoryType = UITableViewCell.AccessoryType.none
                
                let query = PFQuery(className: "Following")
                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                query.whereKey("following", equalTo: objectIds[indexPath.row])
                
                query.findObjectsInBackground(block: { (objects, error) in
                    if let objects = objects {
                        
                        for objects in objects {
                            objects.deleteInBackground()
                        }
                    }
                })
                
            } else {
                
                isFollowing[objectIds[indexPath.row]] = true
                
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                
                let following = PFObject(className: "Following")
                following["follower"] = PFUser.current()?.objectId
                following["following"] = objectIds[indexPath.row]
                
                following.saveInBackground()
                
            }
        }
        
        
        
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    func getUsers() {
        
        let query = PFUser.query()
        
        //remove self user from array
        query?.whereKey("username", notEqualTo: PFUser.current()?.username!)
        
        query?.findObjectsInBackground(block: { (users, error) in
            if error != nil {
                print(error as Any)
                
            } else if let users = users {
                
                self.usernames.removeAll()
                self.objectIds.removeAll()
                self.isFollowing.removeAll()
                
                for object in users{
                    
                    if let user = object as? PFUser {
                        if let username = user.username {
                            if let objectId = user.objectId {
                                
                                let usernameArray = username.components(separatedBy: "@")
                                
                                self.usernames.append(usernameArray[0])
                                self.objectIds.append(objectId)
                                
                                let query = PFQuery(className: "Following")
                                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                                query.whereKey("following", equalTo: objectId)
                                
                                query.findObjectsInBackground(block: { (objects, error) in
                                    if let objects = objects {
                                        if objects.count > 0 {
                                            self.isFollowing[objectId] = true
                                        } else {
                                            self.isFollowing[objectId] = false
                                        }
                                        
                                        self.tableView.reloadData()
                                    }
                                })
                                
                            }
                        }
                    }
                }
                
            }
        })
    }
}
