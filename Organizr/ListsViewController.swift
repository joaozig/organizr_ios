//
//  MainViewController.swift
//  Organizr
//
//  Created by João Ricardo Bastos on 10/10/16.
//  Copyright © 2016 João Ricardo Bastos. All rights reserved.
//

import UIKit
import KeychainSwift

class ListsViewController: UITableViewController {
    
    // MARK: Properties
    
    let cellIdentifier = "listCellIdentifier"
    var lists = [List]()
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.whiteColor()
        navigationBarAppearance.barTintColor = UIColor(rgba: "#930031")
        
        loadLists()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let list = lists[indexPath.row]
        cell.textLabel?.text = list.title
        
        return cell
    }
    
    // MARK: Actions
    
    func loadLists() {
        //        let list1 = List(id: 1, title: "Lista 1")
        //        let list2 = List(id: 2, title: "Lista 2")
        //        lists.append(list1)
        //        lists.append(list2)
        
        HttpService().getRequest(ApiUrl.Lists) { (data, response, error) in
            
            var errorMessage: String?
            
            if error != nil {
                errorMessage = "Something is going wrong with the server. Please try again later."
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? [NSDictionary] {
                            var newLists = [List]()
                            for item in json {
                                let list = List(id: item["id"] as! Int, title: item["title"] as! String)
                                newLists.append(list)
                            }
                            
                            self.lists.appendContentsOf(newLists)
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView.reloadData()
                            }
                        }
                    } else {
                        if let response = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                            
                            errorMessage = String(response["errors"]!)
                        }
                    }
                }
            }

            if errorMessage != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController = UIAlertController(title: "Could not sign in", message: errorMessage!, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
