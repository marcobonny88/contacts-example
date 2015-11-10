//
//  HomeViewController.swift
//  Contacts
//
//  Created by Marco Bonato on 10/11/15.
//  Copyright © 2015 Vooice. All rights reserved.
//

import UIKit

class Entry:NSObject{
    var name:String!
    var surname:String!
    var phone_number:String!
    
    init(name:String, surname:String, phone_number:String){
        self.name = name
        self.surname = surname
        self.phone_number = phone_number
    }
    
    // Get class members name. Used to search across entries.
    class func membersName() -> [String]{
        return ["name","surname","phone_number"]
    }
    
}

//////////////////////////////

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, HomePageDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var searchController:UISearchController!
    
    private var entries = Array<Entry>()
    private var filtered_entries = Array<Entry>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add some entry to populate the table
        entries.append(Entry(name: "Pinco", surname: "Pallino", phone_number: "+39 340 9876543"))
        entries.append(Entry(name: "Pinca", surname: "Pallina", phone_number: "+39 340 6543098"))
        entries.append(Entry(name: "Pincu", surname: "Pallinu", phone_number: "+39 340 1239875"))
        
        // to present the searchbar in this viewcontroller (def. is false)
        self.definesPresentationContext = true

        // add search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    override func prefersStatusBarHidden() -> Bool { return false }
    override func preferredStatusBarStyle() -> UIStatusBarStyle{ return UIStatusBarStyle.LightContent }
    override func shouldAutorotate() -> Bool { return true }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.Portrait
    }

    
    //////////////////////////////
    // Table Delegate & DataSource
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.active){ // when user is searching something
            return self.filtered_entries.count
        }
        return Int(self.entries.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EntryCell
        
        var entry:Entry!
        
        if (self.searchController.active){ // when user is searching something
            entry = filtered_entries[indexPath.row]
        }else{
            entry = entries[indexPath.row]
        }

        cell.name_surname.text = "\(entry.name) \(entry.surname)"
        cell.phone_number.text = entry.phone_number
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.searchController.active){ // when user is searching something
            entry_for_segue = filtered_entries[indexPath.row]
            // save actual entry index to substitute the entry after changes
            filteres_entry_index_for_segue = indexPath.row
            entry_index_for_segue = entries.indexOf(entry_for_segue)
        }else{
            entry_for_segue = entries[indexPath.row]
            entry_index_for_segue = indexPath.row
        }
        self.performSegueWithIdentifier("modify_entry_segue", sender: self)
    }
    
    
    //////////////////////////////
    // SearchBar Delegate
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filtered_entries.removeAll(keepCapacity: false)
        
        // when user has not type something show all the entries
        if searchController.searchBar.text == ""{
            filtered_entries = entries
        }else{
            let members = Entry.membersName()
            // search across entry only by name or phone number, not by surname
            let predicate = NSPredicate(format: "SELF.\(members[0]) CONTAINS[c] %@ || SELF.\(members[2]) CONTAINS[c] %@", searchController.searchBar.text!, searchController.searchBar.text!)
            let array = (entries as NSArray).filteredArrayUsingPredicate(predicate)
            filtered_entries = array as! Array<Entry>
        }
        
        self.tableView.reloadData()
    }
    
    
    //////////////////////////////
    // Add new entry action - (navigation right button)
    
    @IBAction func addNewEntryAction(sender: AnyObject) {
        self.performSegueWithIdentifier("add_entry_segue", sender: self)
    }
    
    
    //////////////////////////////
    // Segue
    
    private var entry_for_segue:Entry!
    private var entry_index_for_segue:Int?
    private var filteres_entry_index_for_segue:Int?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "add_entry_segue"{
            let controller:EntryViewController = segue.destinationViewController as! EntryViewController
            controller.delegate = self
            controller.status = .Add
        }else if segue.identifier == "modify_entry_segue"{
            let controller:EntryViewController = segue.destinationViewController as! EntryViewController
            controller.delegate = self
            controller.status = .Modify
            controller.entry = entry_for_segue
        }
    }
    
    
    //////////////////////////////
    // Homepage delegate

    func addContact(entry:Entry){
        self.entries.append(entry)
        self.tableView.reloadData()
    }
    
    func modifyContact(entry:Entry){
        // change entry in the filtered array
        if (self.searchController.active){ // when user is searching something
            if let index = filteres_entry_index_for_segue{
                self.filtered_entries[index] = entry
            }
        }
        // change entry in the complete entries array
        if let index = entry_index_for_segue{
            self.entries[index] = entry
        }
        self.tableView.reloadData()
    }


}
