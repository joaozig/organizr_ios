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
        let list1 = List(id: 1, title: "Lista 1")
        let list2 = List(id: 2, title: "Lista 2")
        lists.append(list1)
        lists.append(list2)
    }
}
